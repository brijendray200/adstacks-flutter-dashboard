import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../../../data/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import 'common.dart';
import 'edit_dialogs.dart';

class CreatorsPanel extends ConsumerWidget {
  const CreatorsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creators = ref.watch(filteredCreatorsProvider);

    return GestureDetector(
      onLongPress: () async {
        final creator = await showCreatorDialog(context: context);
        if (creator != null) {
          ref.read(dashboardProvider.notifier).addCreator(creator);
        }
      },
      child: DashboardCard(
        color: AppColors.projectNavy,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Creators',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            const _CreatorTableHead(),
            const SizedBox(height: 8),
            if (creators.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Center(
                  child: Text(
                    'No creators found',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              )
            else
              ...creators.map((c) => _CreatorRow(creator: c)),
          ],
        ),
      ),
    );
  }
}

class _CreatorTableHead extends StatelessWidget {
  const _CreatorTableHead();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 5, child: _HeaderText('Name')),
        Expanded(flex: 3, child: _HeaderText('Artworks')),
        Expanded(flex: 4, child: _HeaderText('Rating')),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _CreatorRow extends ConsumerWidget {
  const _CreatorRow({required this.creator});

  final Creator creator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final updated = await showCreatorDialog(
          context: context,
          existing: creator,
        );
        if (updated != null) {
          ref.read(dashboardProvider.notifier).updateCreator(updated);
        }
      },
      onLongPress: () async {
        final confirm = await showConfirmDeleteDialog(
          context: context,
          itemName: creator.handle,
        );
        if (confirm) {
          ref.read(dashboardProvider.notifier).deleteCreator(creator.id);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  InitialAvatar(
                    label: creator.handle.replaceFirst('@', ''),
                    color: creator.avatarColor,
                    size: 32,
                    emoji: creator.avatarEmoji,
                  ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      creator.handle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '${creator.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: creator.progress,
                  backgroundColor: AppColors.line,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.indigoSoft,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
