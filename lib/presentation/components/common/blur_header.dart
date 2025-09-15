import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/presentation/components/common/icon_pill.dart';
import 'package:flutter/material.dart';

/// ───────────────────────── Presentational: Header (sticky görünüm için parent Scaffold+SafeArea yeterli)
class BlurHeader extends StatelessWidget {
  const BlurHeader({super.key, required this.title, this.onClose});

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg.withOpacity(0.8),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconPill(icon: Icons.arrow_back_ios, onTap: onClose),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
