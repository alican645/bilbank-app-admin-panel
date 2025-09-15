import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/register/register_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_view_model.dart';

// Burada ChangeNotifierProvider KURULMUYOR.
// Üst katmanda zaten RegisterViewModel sağlanmış olmalı.

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with RegisterViewMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          body: SafeArea(

            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderBar(title: "Hesap Oluştur"),
                _ChipLabeledField(
                  label: 'E-posta',
                  hintText: 'ornek@site.com',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _ChipLabeledField(
                  label: 'Kullanıcı adı',
                  hintText: 'kullanici_adi',
                  controller: userCtrl,
                ),
                const SizedBox(height: 12),
                _ChipLabeledField(
                  label: 'Ad',
                  hintText: 'Adınız',
                  controller: firstCtrl,
                ),
                const SizedBox(height: 12),
                _ChipLabeledField(
                  label: 'Soyad',
                  hintText: 'Soyadınız',
                  controller: lastCtrl,
                ),
                const SizedBox(height: 12),
                // Doğum tarihi alanını takvime basınca seçtireceğiz
                _ChipLabeledField(
                  label: 'Doğum Tarihi (opsiyonel)',
                  hintText: 'yyyy-MM-dd',
                  controller: birthCtrl,
                  // Eğer alttaki "güncellenmiş alan" sürümünü kullanırsan:
                  // readOnly: true,
                  // onTap: pickBirthDate,
                ),
                const SizedBox(height: 12),
                _ChipLabeledPasswordField(
                  label: 'Şifre',
                  hintText: '••••••••',
                  controller: passCtrl,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: vm.isLoading ? null : () => submit(context),
                    child: vm.isLoading
                        ? const SizedBox(
                            height: 22, width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Hesap Oluştur'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ───────────────────────── Header (geri + başlık)
class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 20, // text-xl
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 48), // başlık tam ortalansın diye (pr-8 karşılığı)
        ],
      ),
    );
  }
}


class _TwoUp extends StatelessWidget {
  const _TwoUp({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final twoCols = c.maxWidth >= 520; // sm breakpoint benzeri
        if (!twoCols) {
          return Column(
            children: [
              left,
              const SizedBox(height: 12),
              right,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _ChipLabeledField extends StatelessWidget {
  const _ChipLabeledField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return _ChipFieldContainer(
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.text, fontSize: 16),
        cursorColor: AppColors.primary,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
        ).copyWith(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.placeholder),
        ),
      ),
    );
  }
}

class _ChipLabeledPasswordField extends StatefulWidget {
  const _ChipLabeledPasswordField({
    required this.label,
    required this.hintText,
    required this.controller,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;

  @override
  State<_ChipLabeledPasswordField> createState() => _ChipLabeledPasswordFieldState();
}

class _ChipLabeledPasswordFieldState extends State<_ChipLabeledPasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return _ChipFieldContainer(
      label: widget.label,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: obscure,
              style: const TextStyle(color: AppColors.text, fontSize: 16),
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ).copyWith(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: AppColors.placeholder),
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => obscure = !obscure),
            splashRadius: 20,
            icon: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.placeholder,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipFieldContainer extends StatefulWidget {
  const _ChipFieldContainer({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  State<_ChipFieldContainer> createState() => _ChipFieldContainerState();
}

class _ChipFieldContainerState extends State<_ChipFieldContainer> {
  final focusNode = FocusNode();
  bool focused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() => setState(() => focused = focusNode.hasFocus));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = focused ? AppColors.primary : AppColors.inputBorder;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeInOut,
          height: 56, // h-14
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          alignment: Alignment.centerLeft,
          child: Focus(
            focusNode: focusNode,
            child: widget.child,
          ),
        ),
        Positioned(
          left: 12,
          top: -10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.background, // arkaplanı yarmak için
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.placeholder,
                fontSize: 12, // text-xs
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48, // h-12
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3332CD6B), // shadow-green-500/20 yaklaşık
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}