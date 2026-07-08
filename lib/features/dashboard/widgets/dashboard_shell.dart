import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/responsive.dart';
import 'center_feed.dart';
import 'left_sidebar.dart';
import 'right_sidebar.dart';
import 'top_bar.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, required this.breakpoint});

  final DashboardBreakpoint breakpoint;

  bool get _isDesktop => breakpoint == DashboardBreakpoint.desktop;
  bool get _isMobile => breakpoint == DashboardBreakpoint.mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _isDesktop ? null : const Drawer(child: LeftSidebar()),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isDesktop) const SizedBox(width: 285, child: LeftSidebar()),
            Expanded(
              child: Container(
                color: AppColors.page,
                child: Column(
                  children: [
                    TopBar(showMenuButton: !_isDesktop, compact: _isMobile),
                    Expanded(
                      child: _DashboardBody(
                        breakpoint: breakpoint,
                        isDesktop: _isDesktop,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isDesktop) const SizedBox(width: 290, child: RightSidebar()),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.breakpoint, required this.isDesktop});

  final DashboardBreakpoint breakpoint;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
        child: const CenterFeed(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        breakpoint == DashboardBreakpoint.mobile ? 16 : 24,
        8,
        breakpoint == DashboardBreakpoint.mobile ? 16 : 24,
        24,
      ),
      child: const Column(
        children: [
          CenterFeed(),
          SizedBox(height: 20),
          RightSidebar(embedded: true),
        ],
      ),
    );
  }
}
