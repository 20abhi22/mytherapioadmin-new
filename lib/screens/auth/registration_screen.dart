import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytherapio_admin_app/backend/api.dart';
import 'package:mytherapio_admin_app/screens/auth/otp_screen.dart';
import 'package:mytherapio_admin_app/widgets/app_button.dart';
import 'package:mytherapio_admin_app/widgets/app_textfield.dart';
import 'package:mytherapio_admin_app/widgets/app_typehead.dart';
import 'package:shared_preferences/shared_preferences.dart';




const Color maincolor = Color(0xFF1B4FD8);

class Country {
  final String flag;
  final String name;
  final String code;
  final String dialCode;
  const Country({
    required this.flag,
    required this.name,
    required this.code,
    required this.dialCode,
  });
}

const List<Country> kCountries = [
  Country(flag: '🇮🇳', name: 'India', code: 'IN', dialCode: '+91'),
  Country(flag: '🇺🇸', name: 'USA', code: 'US', dialCode: '+1'),
  Country(flag: '🇦🇪', name: 'UAE', code: 'AE', dialCode: '+971'),
  Country(flag: '🇬🇧', name: 'UK', code: 'GB', dialCode: '+44'),
  Country(flag: '🇸🇬', name: 'Singapore', code: 'SG', dialCode: '+65'),
  Country(flag: '🇦🇺', name: 'Australia', code: 'AU', dialCode: '+61'),
  Country(flag: '🇨🇦', name: 'Canada', code: 'CA', dialCode: '+1'),
  Country(flag: '🇩🇪', name: 'Germany', code: 'DE', dialCode: '+49'),
];

// ─────────────────────────────────────────────────────────────────
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  // Focus nodes
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  // State
  bool _loading = false;
  bool _firstNameFocused = false;
  bool _lastNameFocused = false;
  bool _phoneFocused = false;
  bool _emailFocused = false;
  Country _selectedCountry = kCountries.first;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
void initState() {
  super.initState();

  _animCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
      .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
  _animCtrl.forward();

  
  _countryCtrl.text =
      "${_selectedCountry.flag} ${_selectedCountry.dialCode}";

  _firstNameFocus.addListener(
      () => setState(() => _firstNameFocused = _firstNameFocus.hasFocus));
  _lastNameFocus.addListener(
      () => setState(() => _lastNameFocused = _lastNameFocus.hasFocus));
  _phoneFocus.addListener(
      () => setState(() => _phoneFocused = _phoneFocus.hasFocus));
  _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus));
}
 @override
void dispose() {
  _animCtrl.dispose();
  _firstNameCtrl.dispose();
  _lastNameCtrl.dispose();
  _phoneCtrl.dispose();
  _emailCtrl.dispose();

  _countryCtrl.dispose();

  _firstNameFocus.dispose();
  _lastNameFocus.dispose();
  _phoneFocus.dispose();
  _emailFocus.dispose();
  super.dispose();
}

  // ── Geo permission + fetch ───────────────────────────────────────
  Future<Position?> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // ── Submit ───────────────────────────────────────────────────────
  Future<void> _submit() async {
  final firstName = _firstNameCtrl.text.trim();
  final lastName  = _lastNameCtrl.text.trim();
  final phone     = _phoneCtrl.text.trim();
  final email     = _emailCtrl.text.trim();

  // ── Validation ─────────────────────────────────────────────────
  if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
    _showError('Please fill all required fields');
    return;
  }
  if (phone.length < 7) {
    _showError('Please enter a valid phone number');
    return;
  }
  if (email.isNotEmpty &&
      !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    _showError('Please enter a valid email address');
    return;
  }

  setState(() => _loading = true);

  // ── Location ────────────────────────────────────────────────────
  final position  = await _getLocation();
  final fullPhone = '$phone';

  // ── API call ────────────────────────────────────────────────────
  final result = await API.registerAdminAPI(
    firstName:   firstName,
    lastName:    lastName,
    countryCode: _selectedCountry.code,       // e.g. "IN"
    phoneCode:   _selectedCountry.dialCode,   // e.g. "+91"
    phone:       fullPhone,                   // e.g. "9876543210"
    fcmToken:    'placeholder_fcm_token',     // TODO: replace with real FCM token
    gmail:       email.isEmpty ? null : email,
    latitude:    position?.latitude.toString(),
    longitude:   position?.longitude.toString(),
  );

  if (!mounted) return;
  setState(() => _loading = false);

  // ── Handle response ─────────────────────────────────────────────
  if (result is Map && result['status'] == 'success') {
    // Persist auth token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', result['token'] ?? '');

    // Navigate to OTP screen for phone verification
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          phone:          fullPhone,
          firstName:      firstName,
          lastName:       lastName,
          email:          email.isEmpty ? null : email,
          latitude:       position?.latitude,
          longitude:      position?.longitude,
          isRegistration: true,
        ),
      ),
    );
  } else {
    final msg = result is Map
        ? (result['message'] ?? 'Registration failed')
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // // ── Country picker bottom sheet ──────────────────────────────────
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
  //             width: 40, height: 4,
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
  //                   leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
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
                      SizedBox(height: size.height * 0.07),

                      // Logo
                      _buildLogo(),
          

                      // Heading
                      const Text('Create account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SFProText',
                            color: Color(0xFF111827),
                            letterSpacing: -0.3,
                          )),
                      const SizedBox(height: 6),
                      const Text(
                          "Fill in your details below. We'll send an OTP to verify your number.",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'SFProText',
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          )),

                      const SizedBox(height: 32),

                      // First & Last name row
                      // Row(children: [
                      //   Expanded(
                      //     child: _buildField(
                      //       controller: _firstNameCtrl,
                      //       focusNode: _firstNameFocus,
                      //       isFocused: _firstNameFocused,
                      //       label: 'First name',
                      //       hint: 'John',
                      //       icon: Icons.person_outline_rounded,
                      //       textInputAction: TextInputAction.next,
                      //       onSubmitted: (_) =>
                      //           _lastNameFocus.requestFocus(),
                      //     ),
                      //   ),
                      //   const SizedBox(width: 12),
                      //   Expanded(
                      //     child: _buildField(
                      //       controller: _lastNameCtrl,
                      //       focusNode: _lastNameFocus,
                      //       isFocused: _lastNameFocused,
                      //       label: 'Last name',
                      //       hint: 'Doe',
                      //       icon: Icons.person_outline_rounded,
                      //       textInputAction: TextInputAction.next,
                      //       onSubmitted: (_) => _phoneFocus.requestFocus(),
                      //     ),
                      //   ),
                      // ]),
                      Column(
  children: [
    _buildField(
      controller: _firstNameCtrl,
      focusNode: _firstNameFocus,
      isFocused: _firstNameFocused,
      label: 'First name',
      hint: 'John',
      icon: Icons.person_outline_rounded,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => _lastNameFocus.requestFocus(),
    ),

    const SizedBox(height: 14),

    _buildField(
      controller: _lastNameCtrl,
      focusNode: _lastNameFocus,
      isFocused: _lastNameFocused,
      label: 'Last name',
      hint: 'Doe',
      icon: Icons.person_outline_rounded,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => _phoneFocus.requestFocus(),
    ),
  ],
),

                      const SizedBox(height: 14),

                      // Phone field with country code
                      _buildPhoneField(),

                      const SizedBox(height: 14),

                      // Email (optional)
                      _buildField(
                        controller: _emailCtrl,
                        focusNode: _emailFocus,
                        isFocused: _emailFocused,
                        label: 'Email',
                        hint: 'john@example.com',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        isOptional: true,
                      ),

                      const SizedBox(height: 16),

                      // Geo note
                      _buildGeoNote(),

                      const SizedBox(height: 28),

                      // Submit button
                      _buildSubmitButton(),

                      const SizedBox(height: 24),

                      // Divider
                      Row(children: [
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  fontFamily: 'SFProText')),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                      ]),

                      const SizedBox(height: 16),

                      // Switch to login
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontFamily: 'SFProText'),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(
                                      color: maincolor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.05),

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
        width: 110, height: 110, fit: BoxFit.contain);
  }

  // ── Phone field with country picker ──────────────────────────────
 Widget _buildPhoneField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Phone number',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFProText',
            color: _phoneFocused ? maincolor : const Color(0xFF374151),
          )),
      const SizedBox(height: 6),

      Row(
        children: [
          // 🔥 TypeAhead Country Picker
          SizedBox(
            width: 70,
            child: AppTypeAhead<Country>(
              controller: _countryCtrl,
              hintText: 'Country',
              items: kCountries,
              itemToString: (c) =>
                  "${c.flag} ${c.name} (${c.dialCode})",
              onSelected: (c) {
                setState(() {
                  _selectedCountry = c;
                });
              },
            ),
          ),

          const SizedBox(width: 10),

          // 🔥 Phone input
          Expanded(
            child: AppTextFeild(
              controller: _phoneCtrl,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              hintText: '98765 43210',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
  // ── Geo note chip ─────────────────────────────────────────────────
  Widget _buildGeoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: maincolor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: maincolor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined,
              size: 16, color: maincolor.withOpacity(0.8)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Your location (lat/lng) will be captured automatically on submit.',
              style: TextStyle(
                  fontSize: 11,
                  color: maincolor,
                  fontFamily: 'SFProText',
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Generic input field ───────────────────────────────────────────
 Widget _buildField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required bool isFocused,
  required String label,
  required String hint,
  required IconData icon,
  bool isOptional = false,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.next,
  ValueChanged<String>? onSubmitted,
  Widget? suffix,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProText',
                color:
                    isFocused ? maincolor : const Color(0xFF374151),
                letterSpacing: 0.1,
              )),
          if (isOptional) ...[
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('optional',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ],
      ),
      const SizedBox(height: 6),

      AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFocused ? maincolor : const Color(0xFFE5E7EB),
            width: isFocused ? 1.6 : 1,
          ),
          color: isFocused
              ? maincolor.withOpacity(0.02)
              : Colors.white,
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: maincolor.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),

        
        child: AppTextFeild(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          hintText: hint,
          onChanged: (_) {},
          suffixIcon: suffix,

          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              icon,
              size: 19,
              color: isFocused
                  ? maincolor
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    ],
  );
}
  // ── Submit button ─────────────────────────────────────────────────
 Widget _buildSubmitButton() {
  return AppButton(
    label: 'Send OTP',
    onPressed: _submit,
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
            Text('KRS TOWER',
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

