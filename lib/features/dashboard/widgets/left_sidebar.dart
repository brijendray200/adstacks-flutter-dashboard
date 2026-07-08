import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../providers/dashboard_providers.dart';
import 'common.dart';
import 'edit_dialogs.dart';

class LeftSidebar extends ConsumerWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final controller = ref.read(dashboardProvider.notifier);

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _LogoMark(),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 16),
                  _ProfileCard(
                    name: state.profile.name,
                    role: state.profile.role,
                    avatarEmoji: state.profile.avatarEmoji,
                    onTap: () async {
                      final result = await showEditProfileDialog(
                        context: context,
                        currentName: state.profile.name,
                        currentRole: state.profile.role,
                      );
                      if (result != null) {
                        controller.updateProfile(
                          name: result.name,
                          role: result.role,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 22),
                  ...state.navigationItems.map(
                    (item) => _NavTile(
                      label: item.label,
                      icon: item.icon,
                      selected: state.selectedSection == item.label,
                      onTap: () {
                        controller.selectSection(item.label);
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WorkspaceSection(
                    expanded: state.isWorkspaceExpanded,
                    workspaces: state.workspaces
                        .map((workspace) => workspace.label)
                        .toList(),
                    onToggle: controller.toggleWorkspace,
                    onAdd: () async {
                      final name = await showAddWorkspaceDialog(
                        context: context,
                      );
                      if (name != null) {
                        controller.addWorkspace(name);
                      }
                    },
                    onRename: (index) async {
                      final newName = await showRenameWorkspaceDialog(
                        context: context,
                        currentName: state.workspaces[index].label,
                      );
                      if (newName != null) {
                        controller.renameWorkspace(index, newName);
                      }
                    },
                    onDelete: (index) async {
                      final confirm = await showConfirmDeleteDialog(
                        context: context,
                        itemName: state.workspaces[index].label,
                      );
                      if (confirm) {
                        controller.deleteWorkspace(index);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ...state.bottomActions.map(
            (action) => _NavTile(
              label: action.label,
              icon: action.icon,
              selected: state.selectedSection == action.label,
              danger: action.label.toLowerCase() == 'logout',
              onTap: () => controller.selectSection(action.label),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.role,
    required this.avatarEmoji,
    required this.onTap,
  });

  final String name;
  final String role;
  final String avatarEmoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(color: AppColors.surface),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.orange, width: 2),
                ),
                child: InitialAvatar(
                  label: name,
                  color: AppColors.indigo,
                  size: 64,
                  emoji: avatarEmoji,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? AppColors.rose
        : selected
        ? const Color(0xFF1E1E2D)
        : AppColors.muted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: selected ? const Color(0xFFF0F1F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 21, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkspaceSection extends StatelessWidget {
  const _WorkspaceSection({
    required this.expanded,
    required this.workspaces,
    required this.onToggle,
    required this.onAdd,
    required this.onRename,
    required this.onDelete,
  });

  final bool expanded;
  final List<String> workspaces;
  final VoidCallback onToggle;
  final VoidCallback onAdd;
  final void Function(int index) onRename;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'WORKSPACES',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .8,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onToggle,
                  onLongPress: onAdd,
                  child: Icon(
                    expanded ? Icons.remove_rounded : Icons.add_rounded,
                    color: AppColors.indigo,
                    size: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Column(
            children: [
              for (var i = 0; i < workspaces.length; i++)
                _WorkspaceBullet(
                  label: workspaces[i],
                  expanded: true,
                  onRename: () => onRename(i),
                  onDelete: () => onDelete(i),
                ),
            ],
          ),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _WorkspaceBullet extends StatelessWidget {
  const _WorkspaceBullet({
    required this.label,
    required this.expanded,
    required this.onRename,
    required this.onDelete,
  });

  final String label;
  final bool expanded;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRename,
      onLongPress: onDelete,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.ink,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Elliptical swoop around AS
                CustomPaint(
                  size: const Size(80, 52),
                  painter: _OrbitSwooshPainter(),
                ),
                // AS text
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'A',
                        style: TextStyle(
                          color: Color(0xFFE13A3A),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'S',
                        style: TextStyle(
                          color: Color(0xFF1C72B5),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 72,
            height: 1.5,
            color: const Color(0xFFD6D8E2),
          ),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Ad',
                  style: TextStyle(
                    color: Color(0xFFE13A3A),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: 'stacks',
                  style: TextStyle(
                    color: Color(0xFF1C72B5),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
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

class _OrbitSwooshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Red swoosh curve underneath A
    paint.color = const Color(0xFFE13A3A);
    final redPath = Path()
      ..moveTo(8, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.95,
        size.width * 0.65,
        size.height * 0.65,
      );
    canvas.drawPath(redPath, paint);

    // Blue swoosh curve arching around S
    paint.color = const Color(0xFF1C72B5);
    final bluePath = Path()
      ..moveTo(size.width * 0.65, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.35,
        size.width * 0.60,
        size.height * 0.12,
      );
    canvas.drawPath(bluePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
