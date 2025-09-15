import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/data/model/model/admin_user.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/users_home/users_home_view_mixin.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/users_home/users_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UsersHomeScreen extends StatefulWidget {
  const UsersHomeScreen({super.key});

  @override
  State<UsersHomeScreen> createState() => _UsersHomeScreenState();
}

class _UsersHomeScreenState extends State<UsersHomeScreen> with UsersHomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Consumer<UsersHomeViewModel>(
          builder: (context, vm, _) {
            final filteredUsers = filterUsers(vm.users);
            final hasErrorWithData = vm.error != null && vm.users.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _HeaderTitle(title: 'Kullanıcılar'),
                _SearchField(
                  controller: searchCtrl,
                  hint: 'Kullanıcı ara',
                  onChanged: (_) {}, // listener mixin'de
                ),
                if (hasErrorWithData)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _ErrorBanner(message: vm.error!),
                  ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (vm.loading && vm.users.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (vm.error != null && vm.users.isEmpty) {
                        return _ErrorState(message: vm.error!);
                      }

                      if (filteredUsers.isEmpty) {
                        return const _EmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh: () => vm.fetchUsers(page: vm.currentPage),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          itemCount: filteredUsers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final user = filteredUsers[i];
                            return _UserTile(
                              name: user.displayName,
                              subtitle:
                                  user.secondaryText.isNotEmpty ? user.secondaryText : null,
                              avatarUrl: user.avatarUrl,
                              status: user.status,
                              onTap: () {
                                context.go(AppPageKeys.userDetailPath);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (vm.pagination != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _PaginationFooter(
                      pagination: vm.pagination!,
                      currentPage: vm.currentPage,
                      onNext: () {
                        final pagination = vm.pagination!;
                        final current = pagination.currentPage ?? vm.currentPage;
                        final total = pagination.totalPages ?? current;
                        if (!pagination.hasNext && current >= total) {
                          return;
                        }
                        final nextPage = current + 1;
                        final targetPage = nextPage > total ? total : nextPage;
                        if (targetPage != current) {
                          vm.fetchUsers(page: targetPage);
                        }
                      },
                      onPrev: () {
                        final pagination = vm.pagination!;
                        final current = pagination.currentPage ?? vm.currentPage;
                        if (!pagination.hasPrev && current <= 1) {
                          return;
                        }
                        final prevPage = current - 1;
                        final targetPage = prevPage < 1 ? 1 : prevPage;
                        if (targetPage != current) {
                          vm.fetchUsers(page: targetPage);
                        }
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: AppColors.text),
            cursorColor: AppColors.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.hint),
              filled: true,
              fillColor: AppColors.field,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(40, 14, 12, 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Icon(Icons.search, color: AppColors.hint),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.status,
    this.onTap,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final String? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;
    final statusText = status?.trim();

    final avatar = hasAvatar
        ? Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover),
            ),
          )
        : Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.field,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.hint),
          );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          color: AppColors.hint,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (statusText != null && statusText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.text),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Kullanıcı bulunamadı',
        style: TextStyle(color: AppColors.hint),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.pagination,
    required this.currentPage,
    required this.onPrev,
    required this.onNext,
  });

  final UsersPagination pagination;
  final int currentPage;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final totalUsers = pagination.totalUsers;
    final rawTotalPages = pagination.totalPages ?? currentPage;
    final totalPages = rawTotalPages <= 0 ? 1 : rawTotalPages;
    final rawCurrent = pagination.currentPage ?? currentPage;
    final displayCurrent = rawCurrent <= 0
        ? 1
        : (rawCurrent > totalPages ? totalPages : rawCurrent);

    return Row(
      children: [
        if (totalUsers != null)
          Text(
            'Toplam $totalUsers kullanıcı',
            style: const TextStyle(color: AppColors.hint),
          )
        else
          const Text(
            'Kullanıcı listesi',
            style: TextStyle(color: AppColors.hint),
          ),
        const Spacer(),
        TextButton(
          onPressed: pagination.hasPrev && displayCurrent > 1 ? onPrev : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.text,
            disabledForegroundColor: AppColors.hint.withOpacity(0.5),
          ),
          child: const Text('Önceki'),
        ),
        const SizedBox(width: 8),
        Text(
          '$displayCurrent / $totalPages',
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: pagination.hasNext && displayCurrent < totalPages ? onNext : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.text,
            disabledForegroundColor: AppColors.hint.withOpacity(0.5),
          ),
          child: const Text('Sonraki'),
        ),
      ],
    );
  }
}
