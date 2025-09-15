import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/data/model/model/room_model.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ───────────────────────── Screen
// room_home.dart (İLGİLİ KISIMLAR)
import 'package:provider/provider.dart';
import 'room_home_view_model.dart';
import 'room_home_view_mixin.dart';

class RoomsHomeScreen extends StatefulWidget {
  const RoomsHomeScreen({super.key});

  @override
  State<RoomsHomeScreen> createState() => _RoomsHomeScreenState();
}

// ⬇️ Mixin eklendi
class _RoomsHomeScreenState extends State<RoomsHomeScreen> with RoomHomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RoomHomeViewModel>(
          builder: (context, vm, _) {
            final items = filterRooms(vm.rooms);

            return Column(
              children: [
                const _Header(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SearchField(
                    controller: searchCtrl,
                    hintText: 'Odaları ara...',
                    onChanged: (_) {}, // listener mixin’de
                  ),
                ),
                const SizedBox(height: 12),
                const _FilterSortSection(),
                const SizedBox(height: 8),

                // Liste / Loading / Error
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (vm.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (vm.error != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(vm.error!, style: const TextStyle(color: AppColors.text)),
                          ),
                        );
                      }
                      if (items.isEmpty) {
                        return const Center(
                          child: Text('Oda bulunamadı', style: TextStyle(color: AppColors.placeholder)),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: vm.fetchRoomData,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final r = items[i];

                            // Alan eşleştirme
                            final title     = r.title ?? 'Oda';
                            final entryFee  = r.entryFee ?? 0;
                            final reward    = r.reward ?? 0;
                            final maxUsers  = r.maxUsers ?? 0;
                            final active    = r.activeReservationCount ?? 0;

                            final isFull = (r.roomStatus == EntryStatus.closed) ||
                                           (maxUsers > 0 && active >= maxUsers);

                            final rewardText  = 'Ödül: $reward';
                            final playersText = isFull
                                ? 'Dolu'
                                : (maxUsers > 0 ? '$active/$maxUsers Oyuncu' : '$active Oyuncu');

                            return RoomCard(
                              title: title,
                              entryFee: entryFee,
                              rewardText: rewardText,
                              playersText: playersText,
                              isFull: isFull,
                              onTap: () {
                                // TODO: Oda detayına gitmek için route
                                context.go(AppPageKeys.roomDetailPath, extra: r);
                              },
                            );
                          },
                        ),
                      );
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

/// ───────────────────────── Header
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text),
          ),
          const Expanded(
            child: Text(
              'Odalar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 20, // text-xl
              ),
            ),
          ),
          const SizedBox(width: 32), // sağ spacing (w-8 ~ 32px)
        ],
      ),
    );
  }
}

/// ───────────────────────── Search Field (ikon solda, border+focus ring)
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final focusNode = FocusNode();
  bool focused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() => setState(() => focused = focusNode.hasFocus));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = focused ? AppColors.primary : Colors.transparent;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              if (focused)
                BoxShadow(
                  color: ringColor.withOpacity(0.25),
                  blurRadius: 8,
                  spreadRadius: 0.5,
                ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            style: const TextStyle(color: AppColors.text, fontSize: 16),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding: const EdgeInsets.fromLTRB(40, 12, 12, 12),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: AppColors.placeholder),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.search, color: AppColors.placeholder),
        ),
      ],
    );
  }
}

/// ───────────────────────── Filter & Sort (Wrap + ChipButton)
class _FilterSortSection extends StatelessWidget {
  const _FilterSortSection();

  @override
  Widget build(BuildContext context) {
    String room_type = '';
    String entry_fee = '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrele & Sırala',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 18, // text-lg
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DropdownChip(
                value: room_type,
                onChanged: (value) {},
                items: ["a", "b", "c", "d"],
                label: 'Oda Tipi',
                trailingIcon: Icons.expand_more,
              ),
              DropdownChip(
                value: entry_fee,
                onChanged: (value) {},
                items: ["a", "b", "c", "d"],
                label: 'Giriş Ücreti',
                trailingIcon: Icons.expand_more,
              ),
              ChipButton(label: 'Ödül', trailingIcon: Icons.swap_vert),
            ],
          ),
        ],
      ),
    );
  }
}

class ChipButton extends StatelessWidget {
  const ChipButton({
    super.key,
    required this.label,
    this.trailingIcon,
    this.onTap,
  });
  final String label;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.chip,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              Icon(trailingIcon, size: 18, color: AppColors.text),
            ],
          ],
        ),
      ),
    );
  }
}

class DropdownChip extends StatefulWidget {
  const DropdownChip({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.trailingIcon = Icons.expand_more,
  });

  /// Chip üzerinde görünen sabit başlık (ör: "Oda Tipi")
  final String label;

  /// Dropdown seçenekleri
  final List<String> items;

  /// Şu anki seçili değer (items içinde olmalı)
  final String value;

  /// Yeni değer seçildiğinde çağrılır
  final ValueChanged<String> onChanged;

  /// Sağdaki ikon (varsayılan expand_more)
  final IconData trailingIcon;

  @override
  State<DropdownChip> createState() => _DropdownChipState();
}

class _DropdownChipState extends State<DropdownChip> {
  final GlobalKey _key = GlobalKey();

  Future<void> _openMenu() async {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Chip'in ekran koordinatı
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + renderBox.size.height + 6, // chip'in altına biraz boşluk
      overlay.size.width - offset.dx - renderBox.size.width,
      0,
    );

    // Koyu tema uyumlu popup menü
    final selected = await showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xFF1C2620), // surface
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: widget.items.map((e) {
        final isSelected = e == widget.value;
        return PopupMenuItem<String>(
          value: e,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  e,
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, size: 18, color: AppColors.primary),
            ],
          ),
        );
      }).toList(),
      elevation: 6,
    );

    if (selected != null && selected != widget.value) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _key,
      borderRadius: BorderRadius.circular(999),
      onTap: _openMenu,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.chip,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tasarıma sadık: sadece label gösteriyoruz (seçilen değeri chip üzerinde göstermiyoruz)
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(widget.trailingIcon, size: 18, color: AppColors.text),
          ],
        ),
      ),
    );
  }
}

/// ───────────────────────── Room Card
class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.title,
    required this.entryFee,
    required this.rewardText,
    required this.playersText,
    required this.isFull,
    required this.onTap,
  });

  final String title;
  final int entryFee;
  final String rewardText;
  final String playersText;
  final bool isFull;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.groups, color: AppColors.text, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 18, // text-lg
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$entryFee',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.toll,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rewardText,
                          style: const TextStyle(
                            color: AppColors.placeholder,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (isFull)
                        Row(
                          children: const [
                            BlinkingDot(),
                            SizedBox(width: 6),
                            Text(
                              'Dolu',
                              style: TextStyle(
                                color: AppColors.placeholder,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          playersText,
                          style: const TextStyle(
                            color: AppColors.placeholder,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kırmızı yanıp sönen nokta (animate-pulse benzeri)
class BlinkingDot extends StatefulWidget {
  const BlinkingDot({super.key});

  @override
  State<BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_c),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
