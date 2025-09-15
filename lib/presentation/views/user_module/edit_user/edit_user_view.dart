import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';





/// ───────────────────────── Container Screen (tüm mantık burada)
class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  // Salt okunur veriler
  final String firstName = 'John';
  final String lastName = 'Doe';
  final String totalPoints = '12500';
  final String email = 'john.doe@example.com';
  final String username = 'johndoe';

  // Düzenlenebilir alanlar
  final TextEditingController triviaCtrl =
      TextEditingController(text: 'Ankara is the capital of Turkey.');
  final TextEditingController balanceCtrl = TextEditingController(text: '500');

  @override
  void dispose() {
    triviaCtrl.dispose();
    balanceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final payload = {
      'firstName': firstName,
      'lastName': lastName,
      'totalPoints': totalPoints,
      'email': email,
      'username': username,
      'trivia': triviaCtrl.text.trim(),
      'balance': balanceCtrl.text.trim(),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kaydedildi: $payload')),
    );
  }

  void _goBack() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            HeaderBar(title: 'Profili Düzenle', onBack: _goBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    ReadOnlyField(label: 'Ad', value: firstName),
                    const SizedBox(height: 16),
                    ReadOnlyField(label: 'Soyad', value: lastName),
                    const SizedBox(height: 16),
                    ReadOnlyField(label: 'Toplam Puan', value: totalPoints),
                    const SizedBox(height: 16),
                    ReadOnlyField(label: 'E-posta', value: email),
                    const SizedBox(height: 16),
                    ReadOnlyField(label: 'Kullanıcı Adı', value: username),
                    const SizedBox(height: 16),
                    EditableField(
                      label: 'Trivia',
                      controller: triviaCtrl,
                      hintText: 'Trivia bilginizi girin',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    EditableField(
                      label: 'Bakiye',
                      controller: balanceCtrl,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      inputFormatters:  [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SaveFooter(buttonText: 'Kaydet', onPressed: _save),
    );
  }
}

/// ───────────────────────── Presentational: Header
class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(999),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(Icons.arrow_back_ios_new, color: AppColors.text, size: 28),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Profili Düzenle',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 20, // text-xl
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 32), // sağda w-8 eşdeğeri boşluk
        ],
      ),
    );
  }
}

/// ───────────────────────── Presentational: Read-only box
class ReadOnlyField extends StatelessWidget {
  const ReadOnlyField({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ───────────────────────── Presentational: Editable TextField
class EditableField extends StatelessWidget {
  const EditableField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: AppColors.text, fontSize: 16),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9EA3AB)),
            isDense: true,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// ───────────────────────── Presentational: Save Footer
class SaveFooter extends StatelessWidget {
  const SaveFooter({super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColors.bg,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.bg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
