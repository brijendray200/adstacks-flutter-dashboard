import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import 'widgets/dashboard_shell.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DashboardShell(
          breakpoint: ResponsiveLayout.breakpointFor(constraints.maxWidth),
        );
      },
    );
  }
}
