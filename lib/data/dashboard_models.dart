import 'package:flutter/material.dart';

enum EventType { birthday, anniversary }

class DashboardProfile {
  const DashboardProfile({
    required this.name,
    required this.role,
    required this.avatarEmoji,
  });

  final String name;
  final String role;
  final String avatarEmoji;
}

class BannerContent {
  const BannerContent({
    required this.kicker,
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  final String kicker;
  final String title;
  final String description;
  final String actionLabel;
}

class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class WorkspaceItem {
  const WorkspaceItem({required this.label});

  final String label;
}

class OfficeHours {
  const OfficeHours({required this.label});

  final String label;
}

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.progress,
    required this.thumbnailEmoji,
  });

  final String id;
  final String title;
  final String description;
  final Color accentColor;
  final double progress;
  final String thumbnailEmoji;
}

class Creator {
  const Creator({
    required this.id,
    required this.handle,
    required this.score,
    required this.progress,
    required this.avatarColor,
    required this.avatarEmoji,
  });

  final String id;
  final String handle;
  final int score;
  final double progress;
  final Color avatarColor;
  final String avatarEmoji;
}

class PerformanceData {
  const PerformanceData({
    required this.year,
    required this.pending,
    required this.done,
  });

  final int year;
  final double pending;
  final double done;
}

class OfficeEvent {
  const OfficeEvent({
    required this.id,
    required this.name,
    required this.type,
    required this.date,
    required this.avatarColor,
    required this.avatarEmoji,
  });

  final String id;
  final String name;
  final EventType type;
  final DateTime date;
  final Color avatarColor;
  final String avatarEmoji;
}
