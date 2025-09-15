// room_home_view_mixin.dart  (GÜNCELLE)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_home/room_home.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_home/room_home_view_model.dart';
import 'package:bilbank_admin_panel/data/model/model/room_model.dart';

mixin RoomHomeViewMixin on State<RoomsHomeScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ekran açılınca odaları çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RoomHomeViewModel>().fetchRoomData();
    });

    // Arama için setState tetikle
    searchCtrl.addListener(() => setState(() {}));
  }

  List<RoomModel> filterRooms(List<RoomModel> rooms) {
    final q = searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return rooms;
    return rooms.where((r) {
      final title = (r.title ?? '').toLowerCase();
      final type  = r.roomType?.label.toLowerCase() ?? '';
      return title.contains(q) || type.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
