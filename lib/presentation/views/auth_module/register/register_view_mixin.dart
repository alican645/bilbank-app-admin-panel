import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_view_model.dart';
import 'package:bilbank_admin_panel/data/model/requests/login_register_request.dart';

mixin RegisterViewMixin<T extends StatefulWidget> on State<T> {
  // Controller’lar
  final emailCtrl = TextEditingController();
  final userCtrl  = TextEditingController();
  final passCtrl  = TextEditingController();
  final firstCtrl = TextEditingController();
  final lastCtrl  = TextEditingController();
  final birthCtrl = TextEditingController(); // yyyy-MM-dd

  // Basit doğrulamalar
  bool _isEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  Future<void> pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100, 1, 1),
      lastDate: now,
    );
    if (picked != null) {
      birthCtrl.text =
          "${picked.year.toString().padLeft(4, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  Future<void> submit(BuildContext context) async {
    // Üstteki Provider’dan VM'i çek
    final vm = context.read<RegisterViewModel>();
    if (vm.isLoading) return;

    // Minimum doğrulama
    final email = emailCtrl.text.trim();
    final user  = userCtrl.text.trim();
    final first = firstCtrl.text.trim();
    final last  = lastCtrl.text.trim();
    final pass  = passCtrl.text;

    if (email.isEmpty || !_isEmail(email)) {
      _toast('Geçerli bir e-posta girin'); return;
    }
    if (user.isEmpty)  { _toast('Kullanıcı adı zorunlu'); return; }
    if (first.isEmpty) { _toast('Ad zorunlu'); return; }
    if (last.isEmpty)  { _toast('Soyad zorunlu'); return; }
    if (pass.isEmpty || pass.length < 6) {
      _toast('Şifre en az 6 karakter olmalı'); return;
    }

    final req = LoginRegisterRequest(
      email: email,
      username: user,
      firstName: first,
      lastName: last,
      password: pass,
      birthDate: birthCtrl.text.trim().isEmpty ? null : birthCtrl.text.trim(),
    );

    final res = await vm.registerAccount(req);
    if (!mounted) return;

    if (res?.isSuccess == true) {
      _toast('Kayıt başarılı.');
      emailCtrl.clear();
      userCtrl.clear();
      passCtrl.clear();
      firstCtrl.clear();
      lastCtrl.clear();
      birthCtrl.clear();
    } else {
      _toast(res?.errorMessage ?? 'Kayıt başarısız.');
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    userCtrl.dispose();
    passCtrl.dispose();
    firstCtrl.dispose();
    lastCtrl.dispose();
    birthCtrl.dispose();
    super.dispose();
  }
}
