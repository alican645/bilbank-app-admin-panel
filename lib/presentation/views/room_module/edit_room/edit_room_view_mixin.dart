


import 'package:bilbank_admin_panel/presentation/views/room_module/edit_room/edit_room_view.dart';
import 'package:flutter/material.dart';

// edit_room_view_mixin.dart (GÜNCELLE)
import 'package:provider/provider.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/edit_room/edit_room_view_model.dart';

mixin EditRoomViewMixin on State<EditRoomScreen> {
  // Controller’lar
  final titleCtrl   = TextEditingController();
  final rewardCtrl  = TextEditingController();
  final entryFeeCtrl= TextEditingController();
  final maxUsersCtrl= TextEditingController();
  final minUsersCtrl= TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ekran çizildikten sonra VM’e odayı ver, alanları doldur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<EditRoomViewModel>();
      vm.initWithRoom(widget.room);                 // ⬅️ dışarıdan gelen oda
      titleCtrl.text    = vm.titleText;
      rewardCtrl.text   = vm.rewardText;
      entryFeeCtrl.text = vm.entryFeeText;
      maxUsersCtrl.text = vm.maxUsersText;
      minUsersCtrl.text = vm.minUsersText;
      setState(() {}); // görsel senkron
    });
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    rewardCtrl.dispose();
    entryFeeCtrl.dispose();
    maxUsersCtrl.dispose();
    minUsersCtrl.dispose();
    super.dispose();
  }
}