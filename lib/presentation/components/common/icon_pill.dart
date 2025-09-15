import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:flutter/material.dart';

class IconPill extends StatelessWidget {
  const IconPill({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: Icon(icon, color: AppColors.text, size: 24)),
      ),
    );
  }
}
