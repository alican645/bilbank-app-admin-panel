// room_users_view_mixin.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_user/room_users_view.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_user/room_users_view_model.dart';

mixin RoomUsersViewMixin on State<RoomUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RoomUsersViewModel>().fetchActiveUsers(widget.roomId);
    });
  }
}
