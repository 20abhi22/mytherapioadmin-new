import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytherapio_admin_app/backend/api.dart';
import 'package:mytherapio_admin_app/routetransitions.dart';
import 'package:mytherapio_admin_app/screens/auth/otp_screen.dart';
import 'package:mytherapio_admin_app/screens/auth/registration_screen.dart';
import 'package:mytherapio_admin_app/widgets/app_button.dart';
import 'package:mytherapio_admin_app/widgets/app_textfield.dart';
import 'package:mytherapio_admin_app/widgets/app_typehead.dart';
import 'package:shared_preferences/shared_preferences.dart';



const Color maincolor = Color(0xFF1B4FD8);

class Country {
  final String flag;
  final String name;
  final String dialCode;
  const Country(
      {required this.flag, required this.name, required this.dialCode});
}

const List<Country> kCountries = [
  Country(flag: '🇮🇳', name: 'India', dialCode: '+91'),
  Country(flag: '🇺🇸', name: 'USA', dialCode: '+1'),
  Country(flag: '🇦🇪', name: 'UAE', dialCode: '+971'),
  Country(flag: '🇬🇧', name: 'UK', dialCode: '+44'),
  Country(flag: '🇸🇬', name: 'Singapore', dialCode: '+65'),
  Country(flag: '🇦🇺', name: 'Australia', dialCode: '+61'),
  Country(flag: '🇨🇦', name: 'Canada', dialCode: '+1'),
  Country(flag: '🇩🇪', name: 'Germany', dialCode: '+49'),
];


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenOtpState();
}

class _LoginScreenOtpState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final _phoneFocus = FocusNode();
  final _countryCtrl = TextEditingController();

  bool _loading = false;
  bool _phoneFocused = false;
  Country _selectedCountry = kCountries.first;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;


  @override
void initState() {
  super.initState();

  

  _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  _fadeAnim = CurvedAnimation(
    parent: _animCtrl,
    curve: Curves.easeOut,
  );

  _slideAnim = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
  );

  _animCtrl.forward();

  
  _phoneFocus.addListener(() {
    setState(() => _phoneFocused = _phoneFocus.hasFocus);
  });

  
  _countryCtrl.text =
      "${_selectedCountry.flag} ${_selectedCountry.dialCode}";
}

 @override
void dispose() {
  _animCtrl.dispose();
  _phoneCtrl.dispose();
  _countryCtrl.dispose();
  _phoneFocus.dispose();
  super.dispose();
}

  // ── Send OTP ──────────────────────────────────────────────────────
Future<void> _sendOtp() async {
  final phone = _phoneCtrl.text.trim();
  if (phone.isEmpty || phone.length < 7) {
    _showError('Please enter a valid phone number');
    return;
  }

  setState(() => _loading = true);

  final result = await API.loginSendOtpAPI(
    countryCode: _selectedCountry.dialCode,  // e.g. "+91"
    phone: phone,                          // e.g. "9876543210" (digits only)
  );

  if (!mounted) return;
  setState(() => _loading = false);

  if (result is Map && result['status'] == 'success') {
    // Save token — Dio interceptor will attach it as Bearer on verify-otp call
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', result['token'] ?? '');

    print('✅ Login OTP Token: ${result['token']}');            // 👈 raw from API
    final saved = prefs.getString('auth_token');
    print('✅ Saved in SharedPrefs: $saved');                   // 👈 confirm persisted
    print('✅ Phone sent: ${_selectedCountry.dialCode} | $phone'); // 👈 confirm payload


    final fullPhone = '${_selectedCountry.dialCode}$phone';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          phone: fullPhone,
          isRegistration: false,
        ),
      ),
    );
  } else {
    final msg = result is Map
        ? (result['message'] ?? 'Failed to send OTP')
        : 'Something went wrong. Please try again.';
    _showError(msg.toString());
  }
}

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontFamily: 'SFProText', fontSize: 13)),
        backgroundColor: const Color(0xFFE24B4A),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // // ── Country picker ────────────────────────────────────────────────
  // void _showCountryPicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  //     builder: (_) => DraggableScrollableSheet(
  //       expand: false,
  //       initialChildSize: 0.55,
  //       maxChildSize: 0.85,
  //       builder: (_, controller) => Column(
  //         children: [
  //           const SizedBox(height: 12),
  //           Container(
  //             width: 40,
  //             height: 4,
  //             decoration: BoxDecoration(
  //                 color: Colors.grey.shade300,
  //                 borderRadius: BorderRadius.circular(2)),
  //           ),
  //           const SizedBox(height: 16),
  //           const Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 20),
  //             child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text('Select country',
  //                   style: TextStyle(
  //                       fontSize: 17,
  //                       fontWeight: FontWeight.w700,
  //                       fontFamily: 'SFProText',
  //                       color: Color(0xFF111827))),
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Expanded(
  //             child: ListView.separated(
  //               controller: controller,
  //               itemCount: kCountries.length,
  //               separatorBuilder: (_, __) =>
  //                   Divider(color: Colors.grey.shade100, height: 1),
  //               itemBuilder: (_, i) {
  //                 final c = kCountries[i];
  //                 final selected = c.dialCode == _selectedCountry.dialCode;
  //                 return ListTile(
  //                   onTap: () {
  //                     setState(() => _selectedCountry = c);
  //                     Navigator.pop(context);
  //                   },
  //                   leading:
  //                       Text(c.flag, style: const TextStyle(fontSize: 22)),
  //                   title: Text(c.name,
  //                       style: TextStyle(
  //                           fontFamily: 'SFProText',
  //                           fontSize: 14,
  //                           fontWeight: selected
  //                               ? FontWeight.w600
  //                               : FontWeight.w400,
  //                           color: selected
  //                               ? maincolor
  //                               : const Color(0xFF111827))),
  //                   trailing: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(c.dialCode,
  //                           style: TextStyle(
  //                               fontFamily: 'SFProText',
  //                               fontSize: 13,
  //                               color: selected
  //                                   ? maincolor
  //                                   : const Color(0xFF6B7280))),
  //                       if (selected) ...[
  //                         const SizedBox(width: 8),
  //                         const Icon(Icons.check_rounded,
  //                             size: 16, color: maincolor),
  //                       ],
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight:
                        size.height - MediaQuery.of(context).padding.top),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.09),

                      // Logo
                      _buildLogo(),
                      const SizedBox(height: 32),

                      // Heading
                      const Text('Sign in',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SFProText',
                            color: Color(0xFF111827),
                            letterSpacing: -0.3,
                          )),
                      const SizedBox(height: 6),
                      const Text(
                          'Enter your phone number. We\'ll send you an OTP to verify.',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'SFProText',
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          )),

                      const SizedBox(height: 36),

                      // Phone field
                      _buildPhoneField(),

                      const SizedBox(height: 28),

                      // Send OTP button
                      _buildSendOtpButton(),

                      const SizedBox(height: 24),

                      // Divider
                      Row(children: [
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Secured with Kernalscape',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  fontFamily: 'SFProText')),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                      ]),

                      const SizedBox(height: 20),

                      // Switch to register
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegistrationScreen()),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              text: 'New user? ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontFamily: 'SFProText'),
                              children: [
                                TextSpan(
                                  text: 'Create an account',
                                  style: TextStyle(
                                      color: maincolor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.07),

                      // Footer
                      _buildFooter(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo ──────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Image.asset('assets/images/logo.png',
        width: 130, height: 130, fit: BoxFit.contain);
  }

  // ── Phone field ───────────────────────────────────────────────────
  // Widget _buildPhoneField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Phone number',
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             fontFamily: 'SFProText',
  //             color: _phoneFocused ? maincolor : const Color(0xFF374151),
  //             letterSpacing: 0.1,
  //           )),
  //       const SizedBox(height: 6),
  //       AnimatedContainer(
  //         duration: const Duration(milliseconds: 180),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(
  //             color: _phoneFocused ? maincolor : const Color(0xFFE5E7EB),
  //             width: _phoneFocused ? 1.6 : 1,
  //           ),
  //           color: _phoneFocused
  //               ? maincolor.withOpacity(0.02)
  //               : Colors.white,
  //           boxShadow: _phoneFocused
  //               ? [
  //                   BoxShadow(
  //                       color: maincolor.withOpacity(0.08),
  //                       blurRadius: 8,
  //                       offset: const Offset(0, 2))
  //                 ]
  //               : [],
  //         ),
  //         child: Row(
  //           children: [
  //             // Country picker
  //             GestureDetector(
  //               onTap: _showCountryPicker,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 12),
  //                 height: 48,
  //                 decoration: BoxDecoration(
  //                   border: Border(
  //                       right: BorderSide(
  //                           color: _phoneFocused
  //                               ? maincolor.withOpacity(0.3)
  //                               : const Color(0xFFE5E7EB))),
  //                   color: const Color(0xFFF9FAFB),
  //                   borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(10),
  //                     bottomLeft: Radius.circular(10),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Text(_selectedCountry.flag,
  //                         style: const TextStyle(fontSize: 18)),
  //                     const SizedBox(width: 6),
  //                     Text(_selectedCountry.dialCode,
  //                         style: const TextStyle(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w600,
  //                             fontFamily: 'SFProText',
  //                             color: Color(0xFF374151))),
  //                     const SizedBox(width: 4),
  //                     Icon(Icons.keyboard_arrow_down_rounded,
  //                         size: 16,
  //                         color: _phoneFocused
  //                             ? maincolor
  //                             : const Color(0xFF9CA3AF)),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // Number input
  //             Expanded(
  //               child: TextField(
  //                 controller: _phoneCtrl,
  //                 focusNode: _phoneFocus,
  //                 keyboardType: TextInputType.phone,
  //                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //                 textInputAction: TextInputAction.done,
  //                 onSubmitted: (_) => _sendOtp(),
  //                 style: const TextStyle(
  //                     fontSize: 14,
  //                     fontFamily: 'SFProText',
  //                     color: Color(0xFF111827)),
  //                 decoration: const InputDecoration(
  //                   hintText: '98765 43210',
  //                   hintStyle: TextStyle(
  //                       fontSize: 13,
  //                       color: Color(0xFFD1D5DB),
  //                       fontFamily: 'SFProText'),
  //                   border: InputBorder.none,
  //                   contentPadding: EdgeInsets.symmetric(
  //                       horizontal: 12, vertical: 14),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPhoneField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Phone number',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'SFProText',
          color: _phoneFocused ? maincolor : const Color(0xFF374151),
        ),
      ),
      const SizedBox(height: 6),

      AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _phoneFocused ? maincolor : const Color(0xFFE5E7EB),
            width: _phoneFocused ? 1.6 : 1,
          ),
          color: _phoneFocused
              ? maincolor.withOpacity(0.02)
              : Colors.white,
        ),

        child: Row(
          children: [

            /// 🔹 COUNTRY TYPEAHEAD
            SizedBox(
              width: 70,
              child: AppTypeAhead<Country>(
                controller: _countryCtrl,
                hintText: '+91',
                items: kCountries,
                itemToString: (c) =>
                    "${c.flag} ${c.name} (${c.dialCode})",
                onSelected: (c) {
                  setState(() {
                    _selectedCountry = c;
                    _countryCtrl.text =
                        "${c.flag} ${c.dialCode}";
                  });
                },
              ),
            ),

            /// 🔹 PHONE INPUT
            Expanded(
              child: AppTextFeild(
                controller: _phoneCtrl,
                focusNode: _phoneFocus,
                hintText: '98765 43210',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (val) {},
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  // ── Send OTP button ───────────────────────────────────────────────
 Widget _buildSendOtpButton() {
  return AppButton(
    label: 'Send OTP',
    onPressed: _sendOtp,
    loading: _loading,
    color: maincolor,
    height: 50,
    suffixIcon: const Icon( 
      Icons.arrow_forward_rounded,
      size: 17,
      color: Colors.white,
    ),
  );
}
  // ── Footer ────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: maincolor),
            ),
            const SizedBox(width: 8),
            Text('MY THERAPIO',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontFamily: 'SFProText')),
          ],
        ),
        const SizedBox(height: 6),
        Text('© ${DateTime.now().year} Kernalscape. All rights reserved.',
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                fontFamily: 'SFProText')),
      ],
    );
  }
}


