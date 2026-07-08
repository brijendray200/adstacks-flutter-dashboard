import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../../../data/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import 'common.dart';
import 'edit_dialogs.dart';

class ProjectsPanel extends ConsumerWidget {
  const ProjectsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(filteredProjectsProvider);
    final selectedProjectId = ref.watch(
      dashboardProvider.select((s) => s.selectedProjectId),
    );

    return DashboardCard(
      color: AppColors.projectNavy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(
            onAdd: () async {
              final project = await showProjectDialog(context: context);
              if (project != null) {
                ref.read(dashboardProvider.notifier).addProject(project);
              }
            },
          ),
          const SizedBox(height: 16),
          if (projects.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'No projects found',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            ...projects.map(
              (project) => _ProjectTile(
                project: project,
                selected: project.id == selectedProjectId,
              ),
            ),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'All Projects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        // Long-press the "..." icon to add a project
        GestureDetector(
          onLongPress: onAdd,
          child: const Icon(Icons.more_horiz_rounded, color: Colors.white70),
        ),
      ],
    );
  }
}

class _ProjectTile extends ConsumerWidget {
  const _ProjectTile({required this.project, required this.selected});

  final Project project;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(dashboardProvider.notifier).selectProject(project.id);
      },
      onLongPress: () async {
        final action = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: const Text('Edit Project'),
                  onTap: () => Navigator.pop(context, 'edit'),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.rose),
                  title: const Text('Delete Project',
                      style: TextStyle(color: AppColors.rose)),
                  onTap: () => Navigator.pop(context, 'delete'),
                ),
              ],
            ),
          ),
        );
        if (action == 'edit') {
          if (!context.mounted) return;
          final updated = await showProjectDialog(
            context: context,
            existing: project,
          );
          if (updated != null) {
            ref.read(dashboardProvider.notifier).updateProject(updated);
          }
        } else if (action == 'delete') {
          if (!context.mounted) return;
          final confirm = await showConfirmDeleteDialog(
            context: context,
            itemName: project.title,
          );
          if (confirm) {
            ref.read(dashboardProvider.notifier).deleteProject(project.id);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.activeRose : AppColors.projectNavy2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: project.accentColor.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    project.id == 'p1'
                        ? Icons.grid_view_rounded
                        : project.id == 'p2'
                        ? Icons.widgets_rounded
                        : Icons.change_history_rounded,
                    color: project.accentColor,
                    size: 28,
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${project.description.split(' - ').first} - ',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: 'See project details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Edit project',
              onPressed: () async {
                final updated = await showProjectDialog(
                  context: context,
                  existing: project,
                );
                if (updated != null) {
                  ref.read(dashboardProvider.notifier).updateProject(updated);
                }
              },
              icon: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
