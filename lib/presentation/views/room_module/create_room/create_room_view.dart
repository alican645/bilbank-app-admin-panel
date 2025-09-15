import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/presentation/components/common/blur_footer.dart';
import 'package:bilbank_admin_panel/presentation/components/common/blur_header.dart';
import 'package:bilbank_admin_panel/presentation/components/common/labeled_dropdown.dart';
import 'package:bilbank_admin_panel/presentation/components/common/labeled_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ───────────────────────── Screen (tüm parametre ve mantık burada)
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  // Form kontrolleri
  final _titleCtrl = TextEditingController();
  final _rewardCtrl = TextEditingController();
  final _entryFeeCtrl = TextEditingController();
  final _maxUsersCtrl = TextEditingController();
  final _minUsersCtrl = TextEditingController();

  String? _roomType;   // 'public' | 'private'
  String? _roomStatus; // 'active' | 'inactive'

  @override
  void dispose() {
    _titleCtrl.dispose();
    _rewardCtrl.dispose();
    _entryFeeCtrl.dispose();
    _maxUsersCtrl.dispose();
    _minUsersCtrl.dispose();
    super.dispose();
  }

  Color get _ring => AppColors.p200;

  void _save() {
    final payload = {
      'title': _titleCtrl.text.trim(),
      'roomType': _roomType,
      'reward': _rewardCtrl.text.trim(),
      'entryFee': _entryFeeCtrl.text.trim(),
      'maxUsers': _maxUsersCtrl.text.trim(),
      'minUsers': _minUsersCtrl.text.trim(),
      'roomStatus': _roomStatus,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kaydet: $payload')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            BlurHeader(
              title: 'Odayı Düzenle',
              onClose: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    LabeledTextField(
                      label: 'Oda Başlığı',
                      hintText: 'Oda başlığını girin',
                      controller: _titleCtrl,
                      ringColor: _ring,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    LabeledDropdown(
                      label: 'Oda Tipi',
                      hintText: 'Oda tipi seçin',
                      value: _roomType,
                      items: const [
                        DropdownMenuItem(value: 'public', child: Text('Herkese Açık')),
                        DropdownMenuItem(value: 'private', child: Text('Özel')),
                      ],
                      ringColor: _ring,
                      onChanged: (v) => setState(() => _roomType = v),
                    ),
                    const SizedBox(height: 16),

                    LabeledTextField(
                      label: 'Ödül',
                      hintText: 'Ödül miktarını girin',
                      controller: _rewardCtrl,
                      ringColor: _ring,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),

                    LabeledTextField(
                      label: 'Giriş Ücreti',
                      hintText: 'Giriş ücretini girin',
                      controller: _entryFeeCtrl,
                      ringColor: _ring,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),

                    LayoutBuilder(
                      builder: (context, c) {
                        final twoCols = c.maxWidth >= 520;
                        final left = LabeledTextField(
                          label: 'Maksimum Kullanıcı',
                          hintText: 'Sayı',
                          controller: _maxUsersCtrl,
                          ringColor: _ring,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        );
                        final right = LabeledTextField(
                          label: 'Minimum Kullanıcı',
                          hintText: 'Sayı',
                          controller: _minUsersCtrl,
                          ringColor: _ring,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        );
                        return twoCols
                            ? Row(children: [Expanded(child: left), const SizedBox(width: 16), Expanded(child: right)])
                            : Column(children: [left, const SizedBox(height: 16), right]);
                      },
                    ),
                    const SizedBox(height: 16),

                    LabeledDropdown(
                      label: 'Oda Durumu',
                      hintText: 'Oda durumunu seçin',
                      value: _roomStatus,
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Aktif')),
                        DropdownMenuItem(value: 'inactive', child: Text('Pasif')),
                      ],
                      ringColor: _ring,
                      onChanged: (v) => setState(() => _roomStatus = v),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            BlurFooter(
              buttonText: 'Kaydet',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}





