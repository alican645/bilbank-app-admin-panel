import 'package:bilbank_admin_panel/data/model/model/admin_user.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/users_home/users_home_view.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/users_home/users_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin UsersHomeViewMixin on State<UsersHomeScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UsersHomeViewModel>().fetchUsers();
    });
    searchCtrl.addListener(() => setState(() {}));
  }

  List<AdminUser> filterUsers(List<AdminUser> users) {
    final query = searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      final name = user.displayName.toLowerCase();
      final username = user.username?.toLowerCase() ?? '';
      final email = user.email?.toLowerCase() ?? '';
      final status = user.status?.toLowerCase() ?? '';
      return name.contains(query) ||
          username.contains(query) ||
          email.contains(query) ||
          status.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
