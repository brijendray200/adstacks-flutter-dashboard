import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/dashboard_models.dart';

// ─── Reusable dialog shell ───────────────────────────────────────────────────

Future<T?> showDashboardDialog<T>({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  return showDialog<T>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _dialogTextField({
  required TextEditingController controller,
  required String label,
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.page,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.indigoSoft, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    ),
  );
}

Widget _dialogSaveButton({
  required VoidCallback onPressed,
  String label = 'Save',
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.indigoSoft,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
  );
}

// ─── Confirm Delete ──────────────────────────────────────────────────────────

Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String itemName,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      content: Text(
        'Are you sure you want to delete "$itemName"?',
        style: const TextStyle(color: AppColors.muted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.rose,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Delete',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

// ─── Edit Profile Dialog ─────────────────────────────────────────────────────

Future<({String name, String role})?> showEditProfileDialog({
  required BuildContext context,
  required String currentName,
  required String currentRole,
}) {
  final nameCtrl = TextEditingController(text: currentName);
  final roleCtrl = TextEditingController(text: currentRole);

  return showDashboardDialog<({String name, String role})>(
    context: context,
    title: 'Edit Profile',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dialogTextField(controller: nameCtrl, label: 'Name'),
        _dialogTextField(controller: roleCtrl, label: 'Role'),
        _dialogSaveButton(
          onPressed: () {
            if (nameCtrl.text.trim().isNotEmpty) {
              Navigator.pop(context, (
                name: nameCtrl.text.trim(),
                role: roleCtrl.text.trim(),
              ));
            }
          },
        ),
      ],
    ),
  );
}

// ─── Edit Banner Dialog ──────────────────────────────────────────────────────

Future<({String kicker, String title, String description})?> showEditBannerDialog({
  required BuildContext context,
  required BannerContent current,
}) {
  final kickerCtrl = TextEditingController(text: current.kicker);
  final titleCtrl = TextEditingController(text: current.title);
  final descCtrl = TextEditingController(text: current.description);

  return showDashboardDialog<({String kicker, String title, String description})>(
    context: context,
    title: 'Edit Banner',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dialogTextField(controller: kickerCtrl, label: 'Kicker'),
        _dialogTextField(controller: titleCtrl, label: 'Title'),
        _dialogTextField(controller: descCtrl, label: 'Description', maxLines: 3),
        _dialogSaveButton(
          onPressed: () {
            Navigator.pop(context, (
              kicker: kickerCtrl.text.trim(),
              title: titleCtrl.text.trim(),
              description: descCtrl.text.trim(),
            ));
          },
        ),
      ],
    ),
  );
}

// ─── Add / Edit Project Dialog ───────────────────────────────────────────────

final List<Color> _projectColors = const [
  AppColors.indigoSoft,
  AppColors.teal,
  AppColors.orange,
  AppColors.rose,
  AppColors.violet,
];

final List<String> _projectEmojis = const ['▦', '◩', '◬', '⬡', '◈'];

Future<Project?> showProjectDialog({
  required BuildContext context,
  Project? existing,
}) {
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final descCtrl = TextEditingController(
    text: existing?.description ?? 'Project #1 - See project details',
  );

  return showDashboardDialog<Project>(
    context: context,
    title: existing != null ? 'Edit Project' : 'Add Project',
    child: _ProjectDialogContent(
      titleCtrl: titleCtrl,
      descCtrl: descCtrl,
      existingId: existing?.id,
      initialColor: existing?.accentColor ?? _projectColors.first,
      initialEmoji: existing?.thumbnailEmoji ?? _projectEmojis.first,
      initialProgress: existing?.progress ?? 0.5,
    ),
  );
}

class _ProjectDialogContent extends StatefulWidget {
  const _ProjectDialogContent({
    required this.titleCtrl,
    required this.descCtrl,
    required this.existingId,
    required this.initialColor,
    required this.initialEmoji,
    required this.initialProgress,
  });

  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final String? existingId;
  final Color initialColor;
  final String initialEmoji;
  final double initialProgress;

  @override
  State<_ProjectDialogContent> createState() => _ProjectDialogContentState();
}

class _ProjectDialogContentState extends State<_ProjectDialogContent> {
  late Color _selectedColor;
  late String _selectedEmoji;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _selectedEmoji = widget.initialEmoji;
    _progress = widget.initialProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogTextField(controller: widget.titleCtrl, label: 'Title'),
        _dialogTextField(
          controller: widget.descCtrl,
          label: 'Description',
          maxLines: 2,
        ),
        const Text(
          'Color',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _projectColors.map((color) {
            final selected = _selectedColor == color;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: AppColors.ink, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Icon',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _projectEmojis.map((emoji) {
            final selected = _selectedEmoji == emoji;
            return GestureDetector(
              onTap: () => setState(() => _selectedEmoji = emoji),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.lavender : AppColors.page,
                  borderRadius: BorderRadius.circular(8),
                  border: selected
                      ? Border.all(color: AppColors.indigoSoft, width: 2)
                      : null,
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.indigoSoft,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Slider(
          value: _progress,
          activeColor: AppColors.indigoSoft,
          onChanged: (v) => setState(() => _progress = v),
        ),
        const SizedBox(height: 8),
        _dialogSaveButton(
          onPressed: () {
            if (widget.titleCtrl.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              Project(
                id: widget.existingId ??
                    'p_${DateTime.now().millisecondsSinceEpoch}',
                title: widget.titleCtrl.text.trim(),
                description: widget.descCtrl.text.trim(),
                accentColor: _selectedColor,
                progress: _progress,
                thumbnailEmoji: _selectedEmoji,
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Add / Edit Creator Dialog ───────────────────────────────────────────────

final List<Color> _creatorColors = const [
  AppColors.indigoSoft,
  AppColors.orange,
  AppColors.teal,
  AppColors.rose,
  AppColors.violet,
];

final List<String> _creatorEmojis = const ['👩', '👨', '👩‍💼', '👨‍💼', '🧑'];

Future<Creator?> showCreatorDialog({
  required BuildContext context,
  Creator? existing,
}) {
  final handleCtrl = TextEditingController(text: existing?.handle ?? '@');
  final scoreCtrl = TextEditingController(
    text: existing?.score.toString() ?? '',
  );

  return showDashboardDialog<Creator>(
    context: context,
    title: existing != null ? 'Edit Creator' : 'Add Creator',
    child: _CreatorDialogContent(
      handleCtrl: handleCtrl,
      scoreCtrl: scoreCtrl,
      existingId: existing?.id,
      initialColor: existing?.avatarColor ?? _creatorColors.first,
      initialEmoji: existing?.avatarEmoji ?? _creatorEmojis.first,
      initialProgress: existing?.progress ?? 0.5,
    ),
  );
}

class _CreatorDialogContent extends StatefulWidget {
  const _CreatorDialogContent({
    required this.handleCtrl,
    required this.scoreCtrl,
    required this.existingId,
    required this.initialColor,
    required this.initialEmoji,
    required this.initialProgress,
  });

  final TextEditingController handleCtrl;
  final TextEditingController scoreCtrl;
  final String? existingId;
  final Color initialColor;
  final String initialEmoji;
  final double initialProgress;

  @override
  State<_CreatorDialogContent> createState() => _CreatorDialogContentState();
}

class _CreatorDialogContentState extends State<_CreatorDialogContent> {
  late Color _selectedColor;
  late String _selectedEmoji;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _selectedEmoji = widget.initialEmoji;
    _progress = widget.initialProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogTextField(controller: widget.handleCtrl, label: 'Handle'),
        _dialogTextField(controller: widget.scoreCtrl, label: 'Artworks Score'),
        const Text(
          'Avatar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _creatorEmojis.map((emoji) {
            final selected = _selectedEmoji == emoji;
            return GestureDetector(
              onTap: () => setState(() => _selectedEmoji = emoji),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.lavender : AppColors.page,
                  borderRadius: BorderRadius.circular(8),
                  border: selected
                      ? Border.all(color: AppColors.indigoSoft, width: 2)
                      : null,
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: _creatorColors.map((color) {
            final selected = _selectedColor == color;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: AppColors.ink, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Text(
              'Rating',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.indigoSoft,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Slider(
          value: _progress,
          activeColor: AppColors.indigoSoft,
          onChanged: (v) => setState(() => _progress = v),
        ),
        const SizedBox(height: 8),
        _dialogSaveButton(
          onPressed: () {
            final handle = widget.handleCtrl.text.trim();
            final score = int.tryParse(widget.scoreCtrl.text.trim()) ?? 0;
            if (handle.isEmpty) return;
            Navigator.pop(
              context,
              Creator(
                id: widget.existingId ??
                    'c_${DateTime.now().millisecondsSinceEpoch}',
                handle: handle,
                score: score,
                progress: _progress,
                avatarColor: _selectedColor,
                avatarEmoji: _selectedEmoji,
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Add Event Dialog ────────────────────────────────────────────────────────

Future<OfficeEvent?> showAddEventDialog({
  required BuildContext context,
  required EventType defaultType,
}) {
  final nameCtrl = TextEditingController();

  return showDashboardDialog<OfficeEvent>(
    context: context,
    title: defaultType == EventType.birthday
        ? 'Add Birthday'
        : 'Add Anniversary',
    child: _EventDialogContent(
      nameCtrl: nameCtrl,
      defaultType: defaultType,
    ),
  );
}

class _EventDialogContent extends StatefulWidget {
  const _EventDialogContent({
    required this.nameCtrl,
    required this.defaultType,
  });

  final TextEditingController nameCtrl;
  final EventType defaultType;

  @override
  State<_EventDialogContent> createState() => _EventDialogContentState();
}

class _EventDialogContentState extends State<_EventDialogContent> {
  late EventType _type;
  DateTime _date = DateTime.now();
  Color _color = AppColors.indigoSoft;
  String _emoji = '👩';

  @override
  void initState() {
    super.initState();
    _type = widget.defaultType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogTextField(controller: widget.nameCtrl, label: 'Name'),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              'Date: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today_rounded, size: 16),
              label: Text(
                '${_date.day}/${_date.month}/${_date.year}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Avatar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['👩', '👨', '👩‍💼', '👨‍💼', '🧑'].map((emoji) {
            final selected = _emoji == emoji;
            return GestureDetector(
              onTap: () => setState(() => _emoji = emoji),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.lavender : AppColors.page,
                  borderRadius: BorderRadius.circular(8),
                  border: selected
                      ? Border.all(color: AppColors.indigoSoft, width: 2)
                      : null,
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            AppColors.indigoSoft,
            AppColors.orange,
            AppColors.teal,
            AppColors.rose,
          ].map((color) {
            final selected = _color == color;
            return GestureDetector(
              onTap: () => setState(() => _color = color),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: AppColors.ink, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _dialogSaveButton(
          onPressed: () {
            final name = widget.nameCtrl.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(
              context,
              OfficeEvent(
                id: 'e_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                type: _type,
                date: _date,
                avatarColor: _color,
                avatarEmoji: _emoji,
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Add Workspace Dialog ────────────────────────────────────────────────────

Future<String?> showAddWorkspaceDialog({required BuildContext context}) {
  final ctrl = TextEditingController();

  return showDashboardDialog<String>(
    context: context,
    title: 'Add Workspace',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dialogTextField(controller: ctrl, label: 'Workspace Name'),
        _dialogSaveButton(
          label: 'Add',
          onPressed: () {
            if (ctrl.text.trim().isNotEmpty) {
              Navigator.pop(context, ctrl.text.trim());
            }
          },
        ),
      ],
    ),
  );
}

// ─── Rename Workspace Dialog ─────────────────────────────────────────────────

Future<String?> showRenameWorkspaceDialog({
  required BuildContext context,
  required String currentName,
}) {
  final ctrl = TextEditingController(text: currentName);

  return showDashboardDialog<String>(
    context: context,
    title: 'Rename Workspace',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dialogTextField(controller: ctrl, label: 'Workspace Name'),
        _dialogSaveButton(
          onPressed: () {
            if (ctrl.text.trim().isNotEmpty) {
              Navigator.pop(context, ctrl.text.trim());
            }
          },
        ),
      ],
    ),
  );
}

// ─── Add Performance Data Dialog ─────────────────────────────────────────────

Future<PerformanceData?> showAddPerformanceDialog({
  required BuildContext context,
}) {
  final yearCtrl = TextEditingController();
  final pendingCtrl = TextEditingController();
  final doneCtrl = TextEditingController();

  return showDashboardDialog<PerformanceData>(
    context: context,
    title: 'Add Performance Data',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dialogTextField(controller: yearCtrl, label: 'Year (e.g. 2024)'),
        _dialogTextField(controller: pendingCtrl, label: 'Pending Done'),
        _dialogTextField(controller: doneCtrl, label: 'Project Done'),
        _dialogSaveButton(
          label: 'Add Data',
          onPressed: () {
            final year = int.tryParse(yearCtrl.text.trim());
            final pending = double.tryParse(pendingCtrl.text.trim());
            final done = double.tryParse(doneCtrl.text.trim());
            if (year != null && pending != null && done != null) {
              Navigator.pop(
                context,
                PerformanceData(year: year, pending: pending, done: done),
              );
            }
          },
        ),
      ],
    ),
  );
}
