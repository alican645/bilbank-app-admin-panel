
import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:flutter/material.dart';

/// ───────────────────────── Presentational: Footer
class BlurFooter extends StatelessWidget {
  const BlurFooter({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg.withOpacity(0.8),
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.p200,
            foregroundColor: AppColors.bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }
}
