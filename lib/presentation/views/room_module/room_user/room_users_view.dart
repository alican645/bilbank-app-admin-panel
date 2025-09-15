import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'room_users_view_model.dart';
import 'room_users_view_mixin.dart';

class RoomUsersScreen extends StatefulWidget {
  const RoomUsersScreen({super.key, required this.roomId});
  final String roomId;

  @override
  State<RoomUsersScreen> createState() => _RoomUsersScreenState();
}

class _RoomUsersScreenState extends State<RoomUsersScreen> with RoomUsersViewMixin {
  void _onBack(BuildContext context) => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Consumer<RoomUsersViewModel>(
          builder: (context, vm, _) {
            Widget body;

            if (vm.loading) {
              body = const Center(child: CircularProgressIndicator());
            } else if (vm.error != null) {
              body = Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(vm.error!, style: const TextStyle(color: AppColors.text)),
                ),
              );
            } else if (vm.users.isEmpty) {
              body = const Center(
                child: Text('Aktif kullanıcı bulunamadı', style: TextStyle(color: AppColors.placeholder)),
              );
            } else {
              body = RefreshIndicator(
                onRefresh: () => context.read<RoomUsersViewModel>().fetchActiveUsers(widget.roomId),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  itemCount: vm.users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, i) {
                    final u = vm.users[i];
                    return UserRow(
                      name: u.name,
                      role: u.role,
                      isAdmin: u.isAdmin,
                      avatarUrl: u.avatarUrl,
                      onTap: () {
                        // İsteğe bağlı: kullanıcı profil detayına git
                        // TODO: context.push(AppPageKeys.userDetailPath, extra: u);
                      },
                    );
                  },
                ),
              );
            }

            return Column(
              children: [
                HeaderBar(title: 'Odadaki Kullanıcılar', onBack: () => _onBack(context)),
                Expanded(child: body),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ───────────────────────── Presentational: Header
class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
        child: Row(
          children: [
            InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(Icons.arrow_back, color: AppColors.text, size: 24),
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 40), // sağ boşluk (pr-10 benzeri)
          ],
        ),
      ),
    );
  }
}

/// ───────────────────────── Presentational: User Row
class UserRow extends StatelessWidget {
  const UserRow({
    super.key,
    required this.name,
    required this.role,
    required this.isAdmin,
    required this.avatarUrl,
    this.onTap,
  });

  final String name;
  final String role;
  final bool isAdmin;
  final String avatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final roleColor = isAdmin ? AppColors.primary : AppColors.hint;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // hover:bg-white/5 yerine hafif overlay efekti için InkWell kullanıyoruz
        ),
        child: Row(
          children: [
            // Avatar (bg-cover, rounded-full)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            // İsim + Rol
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    color: roleColor,
                    fontSize: 14,
                    fontWeight: isAdmin ? FontWeight.w600 : FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

