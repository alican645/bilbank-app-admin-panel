import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/login/login_view_mixin.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// ───────────────────────────────── Screen
// login_view.dart (SADECE İLGİLİ KISIMLAR)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// ⬇️ Mixin eklendi
class _LoginScreenState extends State<LoginScreen> with LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              // ⬇️ Consumer ile tepedeki LoginViewModel’i izliyoruz
              child: Consumer<LoginViewModel>(
                builder: (context, vm, _) {
                  return _LoginFormCard(
                    emailCtrl: emailCtrl,        // mixin’den
                    passCtrl: passCtrl,          // mixin’den
                    isLoading: vm.isLoading,
                    rememberMe: vm.rememberMe,
                    onRememberChanged: (v) => vm.rememberMe = v,
                    onLoginPressed: () => submit(context), // mixin’den
                    onRegisterPressed: () => context.push(AppPageKeys.registerPath),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ───────────────────────────────── Form Card
// login_view.dart (SADECE İLGİLİ KISIMLAR)

// ───────── Form Card
class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({
    required this.emailCtrl,
    required this.passCtrl,
    required this.isLoading,
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onLoginPressed,
    required this.onRegisterPressed,
  });

  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool isLoading;
  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'Giriş Yap',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
            fontSize: 28,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),

        // E-posta
        const _FieldLabel('E-posta'),
        const SizedBox(height: 8),
        RoundedTextField(
          controller: emailCtrl,
          hintText: 'E-posta adresinizi girin',
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
        ),
        const SizedBox(height: 16),

        // Şifre + Şifremi Unuttum
        Row(
          children: [
            const _FieldLabel('Şifre'),
            const Spacer(),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Şifremi Unuttum tıklandı')),
                );
              },
              child: const Text(
                'Şifremi Unuttum',
                style: TextStyle(
                  color: AppColors.hint,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RoundedPasswordField(
          controller: passCtrl,
          hintText: 'Şifrenizi girin',
        ),
        const SizedBox(height: 12),

        // ⬇️ Beni Hatırla
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (v) => onRememberChanged(v ?? false),
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              'Beni hatırla',
              style: TextStyle(color: AppColors.text, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Giriş
        PrimaryButton(
          text: isLoading ? 'Giriş yapılıyor...' : 'Giriş',
          onPressed: isLoading ? () {} : onLoginPressed,
        ),
        const SizedBox(height: 16),

        // Kayıt ol
        PrimaryButton(
          text: 'Kayıt ol',
          onPressed: onRegisterPressed,
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Hesabınız yok mu?'),
            SizedBox(width: 8),
            // (istersen buraya da register yönlendirmesi ekleyebilirsin)
            // GestureDetector(onTap: onRegisterPressed, child: Text('Kayıt Olun')),
          ],
        ),
      ],
    );
  }
}

/// ───────────────────────────────── Label
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.text,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.2,
      ),
    );
  }
}

/// ───────────────────────────────── Inputs
class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return _BaseFieldContainer(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        style: const TextStyle(color: AppColors.text, fontSize: 16),
        decoration: const InputDecoration(border: InputBorder.none).copyWith(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.hint),
        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatefulWidget {
  const RoundedPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _BaseFieldContainer(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              style: const TextStyle(color: AppColors.text, fontSize: 16),
              decoration: const InputDecoration(border: InputBorder.none)
                  .copyWith(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: AppColors.hint),
                  ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            splashRadius: 20,
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.hint,
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseFieldContainer extends StatelessWidget {
  const _BaseFieldContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // h-14
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

/// ───────────────────────────────── Button
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = _hover ? AppColors.primaryHover : AppColors.primary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
