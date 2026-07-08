import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_scroll_behavior.dart';
import 'core/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: AdstacksDashboardApp()));
}

class AdstacksDashboardApp extends StatelessWidget {
  const AdstacksDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adstacks Media Dashboard',
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.light(GoogleFonts.interTextTheme()),
      home: const DashboardScreen(),
    );
  }
}
