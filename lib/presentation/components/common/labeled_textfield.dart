
import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ───────────────────────── Presentational: Labeled TextField
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.ringColor,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final Color ringColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;              

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9EA3AB),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(color: AppColors.text, fontSize: 16),
            cursorColor: ringColor,
            readOnly: readOnly,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.hint),
              filled: true,
              
              fillColor: AppColors.field,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ringColor, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
