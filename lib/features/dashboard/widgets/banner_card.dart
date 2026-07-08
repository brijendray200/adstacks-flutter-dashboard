import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../providers/dashboard_providers.dart';
import 'edit_dialogs.dart';

class BannerCard extends ConsumerWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(dashboardProvider.select((s) => s.banner));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF6329D8), Color(0xFFE77AAB), Color(0xFFF4B4B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withValues(alpha: .24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(right: 12, top: -10, child: _FloatingRing()),
          const Positioned(right: 116, bottom: 30, child: _FloatingCapsule()),
          const Positioned(right: 44, bottom: 16, child: _FloatingDiamond()),
          Positioned(
            right: -36,
            bottom: -50,
            child: Container(
              width: 150,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .86),
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
          GestureDetector(
            onLongPress: () async {
              final result = await showEditBannerDialog(
                context: context,
                current: banner,
              );
              if (result != null) {
                ref.read(dashboardProvider.notifier).updateBanner(
                  kicker: result.kicker,
                  title: result.title,
                  description: result.description,
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                banner.kicker,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                banner.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  banner.description,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21183A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  banner.actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}

class _FloatingRing extends StatelessWidget {
  const _FloatingRing();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.55,
      child: Container(
        width: 104,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1E1735), width: 18),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingCapsule extends StatelessWidget {
  const _FloatingCapsule();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.72,
      child: Container(
        width: 28,
        height: 96,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF55C7FF), Color(0xFF3378F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class _FloatingDiamond extends StatelessWidget {
  const _FloatingDiamond();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: .75,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8C2ED2), Color(0xFF4B168F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
