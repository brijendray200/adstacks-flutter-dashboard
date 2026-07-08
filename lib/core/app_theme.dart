import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light(TextTheme textTheme) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.page,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.indigo,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
      iconTheme: const IconThemeData(color: AppColors.ink),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }
}
