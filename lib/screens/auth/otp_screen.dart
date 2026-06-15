import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytherapio_admin_app/backend/api.dart';
import 'package:mytherapio_admin_app/screens/auth/document_upload_screen.dart';
import 'package:mytherapio_admin_app/screens/auth/login_screen.dart';
import 'package:mytherapio_admin_app/screens/dashboard_screen.dart';
import 'package:mytherapio_admin_app/widgets/app_button.dart';


const Color maincolor = Color(0xFF1B4FD8);

class OtpScreen extends StatefulWidget {
  final String phone;


  final String? firstName;
  final String? lastName;
  final String? email;
  final double? latitude;
  final double? longitude;
  final bool isRegistration;

  const OtpScreen({
    Key? key,
    required this.phone,
    this.firstName,
    this.lastName,
    this.email,
    this.latitude,
    this.longitude,
    this.isRegistration = false,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  // 6 OTP boxes
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus =
      List.generate(6, (_) => FocusNode());

  bool _loading = false;
  int _timerSeconds = 30;
  bool _canResend = false;
  Timer? _timer;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();

    _startTimer();

    // Auto-focus first box
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _otpFocus[0].requestFocus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    super.dispose();
  }

  // ── Timer ─────────────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds == 0) {
        t.cancel();
        if (mounted) setState(() => _canResend = true);
      } else {
        if (mounted) setState(() => _timerSeconds--);
      }
    });
  }

void _resendOtp() async {
  _startTimer();
  for (final c in _otpCtrls) c.clear();
  _otpFocus[0].requestFocus();

  final result = await API.resendOtpAPI();

  if (!mounted) return;
  if (result is Map && result['status'] != 'success') {
    _showError(result['message'] ?? 'Could not resend OTP');
  }
}
  // ── OTP input logic ───────────────────────────────────────────────
  void _onOtpChanged(int index, String value) {
    if (value.length == 1) {
      // Move forward
      if (index < 5) {
        _otpFocus[index + 1].requestFocus();
      } else {
        // Last digit entered — dismiss keyboard
        _otpFocus[index].unfocus();
        // Auto-verify if all filled
        _tryAutoVerify();
      }
    }
  }

  void _onKeyPress(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _otpCtrls[index].text.isEmpty &&
        index > 0) {
      _otpFocus[index - 1].requestFocus();
      _otpCtrls[index - 1].clear();
    }
  }

  void _tryAutoVerify() {
    final otp = _otpCtrls.map((c) => c.text).join();
    if (otp.length == 6) _verifyOtp();
  }

  // ── Verify ────────────────────────────────────────────────────────
Future<void> _verifyOtp() async {
  final otp = _otpCtrls.map((c) => c.text).join();
  if (otp.length < 6) {
    _showError('Please enter the complete 6-digit OTP');
    return;
  }

  setState(() => _loading = true);

  // final result = await API.verifyOtpAPI(otp: otp);
  
final result = widget.isRegistration ? await API.verifyOtpAPI(otp: otp) : await API.verifyLoginOtpAPI(otp: otp);
  if (!mounted) return;
  setState(() => _loading = false);

  if (result is Map && result['status'] == 'success') {
    _showSuccess();
  } else {
    final msg = result is Map
        ? (result['message'] ?? 'Invalid OTP. Please try again.')
        : 'Something went wrong. Please try again.';
    _showError(msg.toString());
  }
}

  void _showError(String msg) {
    // Shake animation on error
    setState(() {});
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

 void _showSuccess() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle_outline_rounded,
              color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text('Verified successfully!',
              style: TextStyle(fontFamily: 'SFProText', fontSize: 13)),
        ],
      ),
      backgroundColor: const Color(0xFF1D9E75),
    ),
  );

  Future.delayed(const Duration(milliseconds: 600), () {
    if (!mounted) return;

    if (widget.isRegistration) {
      /// 🔵 REGISTRATION → LOGIN
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DocumentUploadScreen()),
        (route) => false,
      );
    } else {
      /// 🟢 LOGIN → DASHBOARD
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    }
  });
}

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

                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              size: 18, color: Color(0xFF374151)),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      // Icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: maincolor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                            Icons.phone_android_rounded,
                            color: maincolor,
                            size: 26),
                      ),

                      const SizedBox(height: 20),

                      // Heading
                      const Text('Verify your number',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SFProText',
                            color: Color(0xFF111827),
                            letterSpacing: -0.3,
                          )),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'We sent a 6-digit OTP to ',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'SFProText',
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: widget.phone,
                              style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // OTP boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (i) => _buildOtpBox(i)),
                      ),

                      const SizedBox(height: 28),

                      // Resend row
                      Center(
                        child: _canResend
                            ? GestureDetector(
                                onTap: _resendOtp,
                                child: const Text('Resend OTP',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: maincolor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFProText',
                                    )),
                              )
                            : RichText(
                                text: TextSpan(
                                  text: "Didn't receive it? Resend in ",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                      fontFamily: 'SFProText'),
                                  children: [
                                    TextSpan(
                                      text: '${_timerSeconds}s',
                                      style: const TextStyle(
                                          color: maincolor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                      ),

                      const SizedBox(height: 32),

                      // Verify button
                      _buildVerifyButton(),

                      // Show location info for registration
                      if (widget.isRegistration &&
                          widget.latitude != null &&
                          widget.longitude != null) ...[
                        const SizedBox(height: 16),
                        _buildLocationBadge(),
                      ],

                      SizedBox(height: size.height * 0.08),

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

  // ── Single OTP box ────────────────────────────────────────────────
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 46,
      height: 54,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) => _onKeyPress(index, event),
        child: TextField(
          controller: _otpCtrls[index],
          focusNode: _otpFocus[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => _onOtpChanged(index, v),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'SFProText',
            color: Color(0xFF111827),
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: maincolor, width: 1.8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Verify button ─────────────────────────────────────────────────
 Widget _buildVerifyButton() {
  return AppButton(
    label: 'Verify',
    onPressed: _verifyOtp,
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
  // ── Location badge (shown for registration) ───────────────────────
  Widget _buildLocationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1D9E75).withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFF1D9E75).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              size: 15, color: Color(0xFF1D9E75)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Location: ${widget.latitude!.toStringAsFixed(5)}, ${widget.longitude!.toStringAsFixed(5)}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1D9E75),
                fontFamily: 'SFProText',
              ),
            ),
          ),
        ],
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