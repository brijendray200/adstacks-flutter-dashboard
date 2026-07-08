import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = AppColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class InitialAvatar extends StatelessWidget {
  const InitialAvatar({
    super.key,
    required this.label,
    required this.color,
    this.size = 38,
    this.emoji,
  });

  final String label;
  final Color color;
  final double size;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    // Determine avatar style based on label or emoji
    final isFemale =
        (emoji != null &&
            (emoji!.contains('👩') || emoji!.contains('👧'))) ||
        label.toLowerCase().contains('pooja') ||
        label.toLowerCase().contains('maddison');

    final isCelebration =
        emoji != null && (emoji!.contains('🎩') || emoji!.contains('🎂'));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        size: Size(size, size),
        painter: _AvatarVectorPainter(
          isFemale: isFemale,
          isCelebration: isCelebration,
        ),
      ),
    );
  }
}

class _AvatarVectorPainter extends CustomPainter {
  const _AvatarVectorPainter({
    required this.isFemale,
    required this.isCelebration,
  });

  final bool isFemale;
  final bool isCelebration;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    // 1. Shoulders / Clothes
    paint.color = isFemale
        ? const Color(0xFF2C3E50) // Professional dark navy blazer
        : const Color(0xFF34495E); // Suit jacket
    final shouldersPath = Path()
      ..moveTo(w * 0.15, h)
      ..quadraticBezierTo(w * 0.15, h * 0.68, w * 0.35, h * 0.68)
      ..lineTo(w * 0.65, h * 0.68)
      ..quadraticBezierTo(w * 0.85, h * 0.68, w * 0.85, h)
      ..close();
    canvas.drawPath(shouldersPath, paint);

    // Shirt collar / V-neck accent
    paint.color = Colors.white;
    final collarPath = Path()
      ..moveTo(w * 0.42, h * 0.68)
      ..lineTo(w * 0.5, h * 0.78)
      ..lineTo(w * 0.58, h * 0.68)
      ..close();
    canvas.drawPath(collarPath, paint);

    // 2. Neck
    paint.color = const Color(0xFFF1C27D); // Warm skin tone
    canvas.drawRect(
      Rect.fromLTRB(w * 0.42, h * 0.55, w * 0.58, h * 0.70),
      paint,
    );

    // 3. Face
    canvas.drawCircle(Offset(w * 0.5, h * 0.44), w * 0.22, paint);

    // 4. Hair
    paint.color = isFemale
        ? const Color(0xFF1A1A1A) // Dark stylized hair
        : const Color(0xFF2E1C0C);

    if (isFemale) {
      // Female hairstyle silhouette
      final hairPath = Path()
        ..moveTo(w * 0.26, h * 0.45)
        ..quadraticBezierTo(w * 0.24, h * 0.20, w * 0.5, h * 0.20)
        ..quadraticBezierTo(w * 0.76, h * 0.20, w * 0.74, h * 0.45)
        ..quadraticBezierTo(w * 0.78, h * 0.60, w * 0.70, h * 0.62)
        ..lineTo(w * 0.68, h * 0.35)
        ..quadraticBezierTo(w * 0.5, h * 0.26, w * 0.32, h * 0.35)
        ..lineTo(w * 0.30, h * 0.62)
        ..quadraticBezierTo(w * 0.22, h * 0.60, w * 0.26, h * 0.45)
        ..close();
      canvas.drawPath(hairPath, paint);
    } else {
      // Male hairstyle
      final hairPath = Path()
        ..moveTo(w * 0.28, h * 0.38)
        ..quadraticBezierTo(w * 0.26, h * 0.20, w * 0.5, h * 0.20)
        ..quadraticBezierTo(w * 0.74, h * 0.20, w * 0.72, h * 0.38)
        ..quadraticBezierTo(w * 0.5, h * 0.25, w * 0.28, h * 0.38)
        ..close();
      canvas.drawPath(hairPath, paint);
    }

    // Party hat for celebration cards
    if (isCelebration) {
      paint.color = const Color(0xFFE13A3A);
      final hatPath = Path()
        ..moveTo(w * 0.38, h * 0.24)
        ..lineTo(w * 0.5, h * 0.05)
        ..lineTo(w * 0.62, h * 0.24)
        ..close();
      canvas.drawPath(hatPath, paint);

      paint.color = const Color(0xFFF39C12);
      canvas.drawCircle(Offset(w * 0.5, h * 0.05), w * 0.04, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
