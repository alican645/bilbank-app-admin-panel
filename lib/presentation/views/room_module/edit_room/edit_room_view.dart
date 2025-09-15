// edit_room_view.dart (GÜNCELLE)
import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/presentation/components/common/blur_footer.dart';
import 'package:bilbank_admin_panel/presentation/components/common/blur_header.dart';
import 'package:bilbank_admin_panel/presentation/components/common/labeled_dropdown.dart';
import 'package:bilbank_admin_panel/presentation/components/common/labeled_textfield.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'edit_room_view_model.dart';
import 'edit_room_view_mixin.dart';
import 'package:bilbank_admin_panel/data/model/model/room_model.dart';

class EditRoomScreen extends StatefulWidget {
  const EditRoomScreen({super.key, required this.room});
  final RoomModel room; // ⬅️ oda dışarıdan geliyor

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> with EditRoomViewMixin {
  @override
  Widget build(BuildContext context) {
    const ring = AppColors.p200;

    return Consumer<EditRoomViewModel>(
      builder: (context, vm, _) {
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
                        // Başlık (read-only)
                        LabeledTextField(
                          label: 'Oda Başlığı',
                          hintText: 'Oda başlığını girin',
                          controller: titleCtrl,
                          ringColor: ring,
                          keyboardType: TextInputType.text,
                          readOnly: true, // ⬅️
                        ),
                        const SizedBox(height: 16),

                        // Oda Tipi (read-only görünüm)
                        IgnorePointer(
                          child: Opacity(
                            opacity: 0.8,
                            child: LabeledDropdown(
                              label: 'Oda Tipi',
                              hintText: 'Oda tipi',
                              value: vm.roomTypeLabel, // label gösteriyoruz
                              // salt okunur list (tek elemanlı) — görsel amaçlı
                              items: [
                                DropdownMenuItem(
                                  value: vm.roomTypeLabel,
                                  child: Text(vm.roomTypeLabel),
                                ),
                              ],
                              ringColor: ring,
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Ödül (read-only)
                        LabeledTextField(
                          label: 'Ödül',
                          hintText: 'Ödül miktarı',
                          controller: rewardCtrl,
                          ringColor: ring,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          readOnly: true, // ⬅️
                        ),
                        const SizedBox(height: 16),

                        // Giriş Ücreti (read-only)
                        LabeledTextField(
                          label: 'Giriş Ücreti',
                          hintText: 'Giriş ücreti',
                          controller: entryFeeCtrl,
                          ringColor: ring,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          readOnly: true, // ⬅️
                        ),
                        const SizedBox(height: 16),

                        // 2 kolona böl (read-only)
                        LayoutBuilder(
                          builder: (context, c) {
                            final twoCols = c.maxWidth >= 520;
                            final left = LabeledTextField(
                              label: 'Maksimum Kullanıcı',
                              hintText: 'Sayı',
                              controller: maxUsersCtrl,
                              ringColor: ring,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              readOnly: true, // ⬅️
                            );
                            final right = LabeledTextField(
                              label: 'Minimum Kullanıcı',
                              hintText: 'Sayı',
                              controller: minUsersCtrl,
                              ringColor: ring,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              readOnly: true, // ⬅️
                            );
                            return twoCols
                                ? Row(children: [Expanded(child: left), const SizedBox(width: 16), Expanded(child: right)])
                                : Column(children: [left, const SizedBox(height: 16), right]);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Oda Durumu (read-only)
                        IgnorePointer(
                          child: Opacity(
                            opacity: 0.8,
                            child: LabeledDropdown(
                              label: 'Oda Durumu',
                              hintText: 'Durum',
                              value: vm.roomStatusLabel,
                              items: [
                                DropdownMenuItem(
                                  value: vm.roomStatusLabel,
                                  child: Text(vm.roomStatusLabel),
                                ),
                              ],
                              ringColor: ring,
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Aktif Oyuncular
                BlurFooter(
                  buttonText: 'Aktif Oyuncular',
                  onPressed: () {
                    // (Opsiyonel) önce VM’den fetch:
                    // vm.fetchActiveUsers();
                    context.push(AppPageKeys.roomUsersPath, extra: widget.room.id);
                  },
                ),
                const SizedBox(height: 8),

                // Kaydet (şimdilik read-only; payload demo)
                BlurFooter(
                  buttonText: vm.loading ? 'Kaydediliyor...' : 'Kaydet',
                  onPressed: vm.loading
                      ? () async {}
                      : () async {
                          final payload = {
                            'title': titleCtrl.text.trim(),
                            'reward': rewardCtrl.text.trim(),
                            'entry_fee': entryFeeCtrl.text.trim(),
                            'max_users': maxUsersCtrl.text.trim(),
                            'min_users': minUsersCtrl.text.trim(),
                            // room_type / room_status gibi alanlar backend enum ise burada int’e map edilir
                          };
                          // İLERİDE: API kayıt (şu an salt-okunur, sadece demo)
                          // final res = await vm.saveRoom(payload);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Kaydedildi: $payload')),
                          );
                        },
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
