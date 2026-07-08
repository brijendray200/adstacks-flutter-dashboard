import 'package:flutter/material.dart';

import 'banner_card.dart';
import 'creators_panel.dart';
import 'performance_chart_card.dart';
import 'projects_panel.dart';

class CenterFeed extends StatelessWidget {
  const CenterFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 850;

        return Column(
          children: [
            const BannerCard(),
            const SizedBox(height: 20),
            if (twoColumns)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: ProjectsPanel()),
                  SizedBox(width: 20),
                  Expanded(flex: 5, child: CreatorsPanel()),
                ],
              )
            else
              const Column(
                children: [
                  ProjectsPanel(),
                  SizedBox(height: 20),
                  CreatorsPanel(),
                ],
              ),
            const SizedBox(height: 20),
            const PerformanceChartCard(),
          ],
        );
      },
    );
  }
}
