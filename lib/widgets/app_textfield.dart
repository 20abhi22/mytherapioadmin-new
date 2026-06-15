import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytherapio_admin_app/screens/auth/login_screen.dart';

class AppTextFeild extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
    final List<TextInputFormatter>? inputFormatters;

  const AppTextFeild({
    Key? key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.validator,
     this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator,
       inputFormatters: inputFormatters,
      style: const TextStyle(
          color: Colors.black, fontSize: 14, fontFamily: 'SFProText'),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: maincolor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red, width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.1),
        ),
      ),
    );
  }
}
