import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'dashboard_models.dart';

class DashboardRepository {
  const DashboardRepository();

  DashboardProfile profile() => const DashboardProfile(
    name: 'Pooja Mishra',
    role: 'Admin',
    avatarEmoji: '👩‍💼',
  );

  BannerContent banner() => const BannerContent(
    kicker: 'ETHEREUM 2.0',
    title: 'Top Rating\nProject',
    description: 'Trending project and high rating\nProject Created by team.',
    actionLabel: 'Learn More.',
  );

  OfficeHours officeHours() =>
      const OfficeHours(label: 'GENERAL 10:00 AM TO 7:00 PM');

  List<NavItem> navigationItems() => const [
    NavItem(label: 'Home', icon: Icons.home_rounded),
    NavItem(label: 'Employees', icon: Icons.groups_rounded),
    NavItem(label: 'Attendance', icon: Icons.checklist_rounded),
    NavItem(label: 'Summary', icon: Icons.calendar_month_rounded),
    NavItem(label: 'Information', icon: Icons.info_outline),
  ];

  List<WorkspaceItem> workspaces() => const [
    WorkspaceItem(label: 'Adstacks'),
    WorkspaceItem(label: 'Finance'),
  ];

  List<NavItem> bottomActions() => const [
    NavItem(label: 'Setting', icon: Icons.settings_rounded),
    NavItem(label: 'Logout', icon: Icons.logout_rounded),
  ];

  List<Project> projects() => const [
    Project(
      id: 'p1',
      title: 'Technology behind the Blockchain',
      description: 'Project #1 - See project details',
      accentColor: AppColors.indigoSoft,
      progress: .82,
      thumbnailEmoji: '▦',
    ),
    Project(
      id: 'p2',
      title: 'Technology behind the Blockchain',
      description: 'Project #1 - See project details',
      accentColor: AppColors.teal,
      progress: .68,
      thumbnailEmoji: '◩',
    ),
    Project(
      id: 'p3',
      title: 'Technology behind the Blockchain',
      description: 'Project #1 - See project details',
      accentColor: AppColors.orange,
      progress: .74,
      thumbnailEmoji: '◬',
    ),
  ];

  List<Creator> creators() => const [
    Creator(
      id: 'c1',
      handle: '@maddison_c21',
      score: 9821,
      progress: .92,
      avatarColor: AppColors.indigoSoft,
      avatarEmoji: '👩',
    ),
    Creator(
      id: 'c2',
      handle: '@karl.will02',
      score: 7032,
      progress: .72,
      avatarColor: AppColors.orange,
      avatarEmoji: '👨',
    ),
    Creator(
      id: 'c3',
      handle: '@maddison_c21',
      score: 9821,
      progress: .61,
      avatarColor: AppColors.teal,
      avatarEmoji: '👩',
    ),
    Creator(
      id: 'c4',
      handle: '@maddison_c21',
      score: 9821,
      progress: .54,
      avatarColor: AppColors.rose,
      avatarEmoji: '👩',
    ),
  ];

  List<PerformanceData> performance() => const [
    PerformanceData(year: 2015, pending: 18, done: 24),
    PerformanceData(year: 2016, pending: 28, done: 31),
    PerformanceData(year: 2017, pending: 22, done: 38),
    PerformanceData(year: 2018, pending: 35, done: 43),
    PerformanceData(year: 2019, pending: 30, done: 55),
    PerformanceData(year: 2020, pending: 42, done: 68),
  ];

  List<OfficeEvent> events() => [
    OfficeEvent(
      id: 'e1',
      name: 'Riya',
      type: EventType.birthday,
      date: DateTime(2023, 10, 10),
      avatarColor: AppColors.indigoSoft,
      avatarEmoji: '👩',
    ),
    OfficeEvent(
      id: 'e2',
      name: 'Aman',
      type: EventType.birthday,
      date: DateTime(2023, 10, 22),
      avatarColor: AppColors.orange,
      avatarEmoji: '👨‍💼',
    ),
    OfficeEvent(
      id: 'e3',
      name: 'Nisha',
      type: EventType.anniversary,
      date: DateTime(2023, 10, 8),
      avatarColor: AppColors.teal,
      avatarEmoji: '👩',
    ),
    OfficeEvent(
      id: 'e4',
      name: 'Karan',
      type: EventType.anniversary,
      date: DateTime(2023, 10, 16),
      avatarColor: AppColors.rose,
      avatarEmoji: '👨‍💼',
    ),
    OfficeEvent(
      id: 'e5',
      name: 'Meera',
      type: EventType.anniversary,
      date: DateTime(2023, 10, 29),
      avatarColor: AppColors.indigoSoft,
      avatarEmoji: '👨‍💼',
    ),
  ];
}
