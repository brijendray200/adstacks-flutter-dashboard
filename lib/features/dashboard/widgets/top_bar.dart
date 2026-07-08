import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../providers/dashboard_providers.dart';
import 'common.dart';

class TopBar extends ConsumerWidget {
  const TopBar({
    super.key,
    required this.showMenuButton,
    required this.compact,
  });

  final bool showMenuButton;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(
      dashboardProvider.select((s) => s.selectedSection),
    );
    final profile = ref.watch(dashboardProvider.select((s) => s.profile));
    final query = ref.watch(searchQueryProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 12 : 28,
        18,
        compact ? 12 : 28,
        14,
      ),
      child: Row(
        children: [
          if (showMenuButton)
            IconButton.filledTonal(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          if (showMenuButton) const SizedBox(width: 10),
          Flexible(
            child: Text(
              selectedSection,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: compact ? 20 : 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: compact ? 8 : 20),
          if (!compact)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: _SearchField(query: query),
                ),
              ),
            )
          else
            const Spacer(),
          if (!compact) const SizedBox(width: 12),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _UtilityIcon(icon: Icons.description_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _UtilityIcon(
                    icon: Icons.notifications_none_rounded,
                    showBadge: true,
                    onTap: () {},
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 8),
                    _UtilityIcon(
                      icon: Icons.power_settings_new_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    InitialAvatar(
                      label: profile.name,
                      color: AppColors.rose,
                      size: 38,
                      emoji: profile.avatarEmoji,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF21183A),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: ref.read(searchQueryProvider.notifier).update,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (query.isNotEmpty)
            IconButton(
              tooltip: 'Clear search',
              onPressed: ref.read(searchQueryProvider.notifier).clear,
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: Colors.white70,
              ),
            ),
          const Icon(Icons.search_rounded, color: Colors.white70, size: 20),
        ],
      ),
    );
  }
}

class _UtilityIcon extends StatelessWidget {
  const _UtilityIcon({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: '',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            fixedSize: const Size(44, 44),
          ),
          onPressed: onTap,
          icon: Icon(icon, size: 21),
        ),
        if (showBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.rose,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
