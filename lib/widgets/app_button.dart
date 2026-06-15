import 'package:flutter/material.dart';

const Color _zohoBlue = Color(0xFF0066CC);

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outline;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? color;
  final double? width;
  final double height;

  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.outline = false,
    this.prefixIcon,
    this.suffixIcon, 
    this.color,
    this.width,
    this.height = 44,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? _zohoBlue;

    if (outline) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            backgroundColor: Colors.white,
            side: BorderSide(color: buttonColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          ),
          child: loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: buttonColor),
                )
              : Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (prefixIcon != null) ...[
      prefixIcon!,
      const SizedBox(width: 8),
    ],

    Text(
      label,
      style: TextStyle(
        color: outline ? buttonColor : Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        fontFamily: 'SFProText',
      ),
    ),

    if (suffixIcon != null) ...[
      const SizedBox(width: 8),
      suffixIcon!,
    ],
  ],
)
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: buttonColor.withOpacity(0.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 8)],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'SFProText',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
