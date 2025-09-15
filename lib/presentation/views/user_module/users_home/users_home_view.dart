import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




/// Veri modeli
class AppUser {
  final String name;
  final String? avatarUrl; // null ise placeholder ikon
  const AppUser(this.name, this.avatarUrl);
}

/// Container (tüm mantık burada)
class UsersHomeScreen extends StatefulWidget {
  const UsersHomeScreen({super.key});

  @override
  State<UsersHomeScreen> createState() => _UsersHomeScreenState();
}

class _UsersHomeScreenState extends State<UsersHomeScreen> {
  final _searchCtrl = TextEditingController();

  final List<AppUser> _users = const [
    AppUser('Elif Demir',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAS9JSch3bds1eG9tH4W1dyrZrFwdUtTvjhLBzl0J2w_k2_K6TUFOaubhnL2sqmR32UvCLwfro4LCU0Lmvcgd1-drpAbGeZO3qUqXMbx82TgUFTmbjQcIHN5pGzZ6jbWHJzchQFjxEh683iHaGKGn-fYCXu62I3x_fM31bH6J3YVEmmHY6sDOvREX1LJtRr9vXtXVuRbU1h06KRJPTCmJ-O4xtN_febfrp9dFPNNGHSc6_Y0o0Z8p00ZbC3g-Q9SUvbP-gmGFvdMTU'),
    AppUser('Ahmet Yılmaz',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB1vk52OUs4u9xPWDaEDqrvPzIJYoNVMHc1J2xEYSf6_m8zS_djQD6iYFh5R-JOO5dIKaKJwiYQJKAM46Z9es-6U4J3HbZ5SNiL3aEXvPoRVRMJyQjW_6guHQKqZMJbfuXfzbEenFpCF5Eb-aFiNsKGmBX6heQhGQj_LPSCPTRM1lp6SszqRrqqWxaKGjpcKmRCHoLuGzMoJwF8RgZTVj1RBonn_9vCXAHEZYUyFQrV6HnzWqhVmEBwoew7PLuGyW7XAuPX9jvu7ys'),
    AppUser('Ayşe Kaya',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDgUpErorFArpPK1q7OIR1QEPwPVT1uXw3IqWn3owXSk1H8yAbUg0n4GuuH3hbCOk-XYQEtw_IGk0kMHkh4DlHf0O9NawKE-O-Kifgggi56yibFM-rUkumToqfLi5U4Xe63NQbUfq67mxLgq5dbXRMTSstliVParoYMaoq1QBg81bPQP-RTX2tvRDchtahkwKHE9QbxuvC5y4WJ3TK2dYCkHdFTgolqVIGNMpkKAW32t2MavEZLwz_rQQh2l9Fj8hRuCnrSrEx0c5I'),
    AppUser('Mehmet Öztürk',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB_iI9Fp_rnFOYgyQNb-mt-Rj4OD9yx0y-Vz6YHYxhakpwwQoFfqpWv4_43EHA1sV2AzfPhbOkY9Ksy8-yQjQs32cSPYpmhl45WDJi2KsrPawQvBcOVSHteXYjTefRjYJqkQCpAYAWR9b3h38M41kOL6810ENhMcM74ZfvDATl3Ed9r0ODPewsTowKsrswulH0mtR_4jldHCKn8PCgnE21YHXresOx-FWWjBriARNkheHx9fjCyF9yq14sevkyZMq7j_r-RDk5J3gU'),
    AppUser('Zeynep Can',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAIvPtguWtjMRXKccNLNbp10xVmQvkbzLmx2JEakHo-rK41taLPDwEeoAkBzwpLkATvO6in8dlTQOsiuGouCUGiHamMnifTzDOWQPu-mT7hzSwd1AMHeU233uP_ZPFX1KBVlGek4-sE7BDy0rr3cBirMu8p9M2vDDV50RA7gTXfhcVFkBqOKZbMuS_HGBkyB4nv9pMwLQ3qsV5EJ2WTEhkHa8nxZMdkvRvpDabKKJEhlZaQDyy_Nq3vA2NjVuGSe4N93IcgvMEMYx4'),
    AppUser('Ali Veli', null), // placeholder ikonlu
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AppUser> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _users;
    return _users.where((u) => u.name.toLowerCase().contains(q)).toList();
  }

  void _onSearchChanged(String _) => setState(() {});

  void _onNavTap(int i) {
    // navigation stratejine göre yönlendir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderTitle(title: 'Kullanıcılar'),
            _SearchField(
              controller: _searchCtrl,
              hint: 'Kullanıcı ara',
              onChanged: _onSearchChanged,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final u = _filtered[i];
                  return _UserTile(
                    name: u.name,
                    avatarUrl: u.avatarUrl,
                    onTap: () {
                      context.go(AppPageKeys.userDetailPath);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Presentational: Header
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
                fontSize: 20, // text-xl
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Presentational: Arama alanı (ikon + input)
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

/// Presentational: Kullanıcı satırı
class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.name,
    required this.avatarUrl,
    this.onTap,
  });

  final String name;
  final String? avatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = avatarUrl == null
        ? Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.field,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.hint),
          )
        : Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover),
            ),
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
            Text(
              name,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
