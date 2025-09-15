// login_view_mixin.dart (TAMAMINI GÜNCELLE)

import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/login/login_view.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/login/login_view_model.dart';

mixin LoginViewMixin on State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Remembered değerleri yükle ve alanları doldur
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<LoginViewModel>();
      await vm.loadRememberedValues();
      emailCtrl.text = vm.email;
      passCtrl.text  = vm.password;
      if (mounted) setState(() {});
    });
  }

  bool _isEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  Future<void> submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final email = emailCtrl.text.trim();
    final pass  = passCtrl.text;

    if (email.isEmpty || !_isEmail(email)) {
      _toast('Geçerli bir e-posta girin'); return;
    }
    if (pass.isEmpty || pass.length < 6) {
      _toast('Şifre en az 6 karakter olmalı'); return;
    }

    final vm = context.read<LoginViewModel>();
    final ok = await vm.login(email, pass);

    if (!mounted) return;
    if (ok) {
      _toast('Giriş başarılı');

      context.go(AppPageKeys.roomHome);

    } else {
      final msg = vm.apiResponse?.errorMessage ?? 'Giriş başarısız';
      _toast(msg);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
