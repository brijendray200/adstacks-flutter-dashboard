import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_colors.dart';
import '../../../data/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import 'common.dart';
import 'edit_dialogs.dart';

class RightSidebar extends ConsumerWidget {
  const RightSidebar({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthdays = ref.watch(birthdayEventsProvider);
    final anniversaries = ref.watch(anniversaryEventsProvider);
    final state = ref.watch(dashboardProvider);
    final officeHours = state.officeHours.label;

    return Container(
      margin: embedded
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.night,
        borderRadius: embedded ? BorderRadius.circular(8) : BorderRadius.zero,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    officeHours,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _CalendarCard(
                focusedDay: state.focusedCalendarDay,
                selectedDay: state.selectedCalendarDay,
              ),
              const SizedBox(height: 18),
              _EventCard(
                title: 'Today Birthday',
                total: birthdays.length,
                events: birthdays,
                actionLabel: 'Birthday Wishing',
                eventType: EventType.birthday,
              ),
              const SizedBox(height: 16),
              _EventCard(
                title: 'Anniversary',
                total: anniversaries.length,
                events: anniversaries,
                actionLabel: 'Anniversary Wishing',
                eventType: EventType.anniversary,
              ),
            ],
          ),
        ),
    );
  }
}

class _CalendarCard extends ConsumerWidget {
  const _CalendarCard({required this.focusedDay, required this.selectedDay});

  final DateTime focusedDay;
  final DateTime selectedDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: TableCalendar<void>(
        focusedDay: focusedDay,
        firstDay: DateTime(2020),
        lastDay: DateTime(2030),
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        onDaySelected: ref.read(dashboardProvider.notifier).selectCalendarDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.indigo,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.indigo,
          ),
          titleTextStyle: TextStyle(
            color: AppColors.indigo,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppColors.ink.withValues(alpha: .70)),
          weekendStyle: const TextStyle(color: AppColors.indigo),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: const TextStyle(color: AppColors.ink),
          weekendTextStyle: const TextStyle(color: AppColors.indigo),
          todayDecoration: BoxDecoration(
            color: AppColors.indigoSoft.withValues(alpha: .45),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.lavender,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: AppColors.indigo,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({
    required this.title,
    required this.total,
    required this.events,
    required this.actionLabel,
    required this.eventType,
  });

  final String title;
  final int total;
  final List<OfficeEvent> events;
  final String actionLabel;
  final EventType eventType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.night2,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Long-press on title row to add new event
                GestureDetector(
                  onLongPress: () async {
                    final event = await showAddEventDialog(
                      context: context,
                      defaultType: eventType,
                    );
                    if (event != null) {
                      ref.read(dashboardProvider.notifier).addEvent(event);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.orange,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (events.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No events yet',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                else
                  SizedBox(
                    height: 42,
                    child: Stack(
                      children: [
                        for (var index = 0; index < events.length; index++)
                          Positioned(
                            left: index * 30,
                            child: GestureDetector(
                              onLongPress: () async {
                                final confirm = await showConfirmDeleteDialog(
                                  context: context,
                                  itemName: events[index].name,
                                );
                                if (confirm) {
                                  ref
                                      .read(dashboardProvider.notifier)
                                      .deleteEvent(events[index].id);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.night2,
                                  shape: BoxShape.circle,
                                ),
                                child: InitialAvatar(
                                  label: events[index].name,
                                  color: events[index].avatarColor,
                                  size: 40,
                                  emoji: events[index].avatarEmoji,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .58),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(width: 1, height: 22, color: Colors.white24),
                    const SizedBox(width: 14),
                    Text(
                      '$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(width: 1, height: 22, color: Colors.white24),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.violet,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(22),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    actionLabel,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
