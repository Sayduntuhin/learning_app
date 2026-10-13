import 'dart:math' as math;
import 'package:flutter/material.dart';

enum CountryFlag {
  usa,
  uk,
  russia,
  germany,
  spain,
  portugal,
  france,
  italy,
  japan,
  korea,
  bengali,
  arabic,
  ukraine,
  indonesia,
  turkey,
  china,
  poland,
}

/// Reusable country flag widget supporting both modern rounded-rectangular badges and circular tokens.
class FlagIconWidget extends StatelessWidget {
  final CountryFlag flag;
  final double size;
  final double? width;
  final double? height;
  final bool isCircular;
  final double borderRadius;

  const FlagIconWidget({
    super.key,
    required this.flag,
    this.size = 38,
    this.width,
    this.height,
    this.isCircular = false,
    this.borderRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final flagWidth = width ?? (isCircular ? size : 38.0);
    final flagHeight = height ?? (isCircular ? size : 26.0);

    if (isCircular) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: CustomPaint(
            size: Size(size, size),
            painter: _FlagPainter(flag),
          ),
        ),
      );
    }

    return Container(
      width: flagWidth,
      height: flagHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 0.5),
        child: CustomPaint(
          size: Size(flagWidth, flagHeight),
          painter: _FlagPainter(flag),
        ),
      ),
    );
  }
}

class _FlagPainter extends CustomPainter {
  final CountryFlag flag;

  _FlagPainter(this.flag);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (flag) {
      case CountryFlag.usa:
        // USA: 13 stripes (7 red, 6 white) + blue canton + stars
        final stripeH = h / 13;
        final redPaint = Paint()..color = const Color(0xFFB22234);
        final whitePaint = Paint()..color = Colors.white;

        for (int i = 0; i < 13; i++) {
          canvas.drawRect(
            Rect.fromLTWH(0, i * stripeH, w, stripeH),
            i.isEven ? redPaint : whitePaint,
          );
        }

        // Blue canton
        final cantonW = w * 0.44;
        final cantonH = stripeH * 7;
        final bluePaint = Paint()..color = const Color(0xFF3C3B6E);
        canvas.drawRect(Rect.fromLTWH(0, 0, cantonW, cantonH), bluePaint);

        // Star points representation on canton
        final starPaint = Paint()..color = Colors.white;
        const rows = 4;
        const cols = 5;
        for (int r = 0; r < rows; r++) {
          for (int c = 0; c < cols; c++) {
            final cx = (c + 0.8) * (cantonW / (cols + 0.6));
            final cy = (r + 0.8) * (cantonH / (rows + 0.6));
            canvas.drawCircle(Offset(cx, cy), 1.0, starPaint);
          }
        }
        break;

      case CountryFlag.germany:
        final paint = Paint()..style = PaintingStyle.fill;
        paint.color = const Color(0xFF1E1E1E);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h / 3), paint);
        paint.color = const Color(0xFFDE0000);
        canvas.drawRect(Rect.fromLTWH(0, h / 3, w, h / 3), paint);
        paint.color = const Color(0xFFFFCE00);
        canvas.drawRect(Rect.fromLTWH(0, 2 * h / 3, w, h / 3), paint);
        break;

      case CountryFlag.russia:
        final paint = Paint()..style = PaintingStyle.fill;
        paint.color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h / 3), paint);
        paint.color = const Color(0xFF0039A6);
        canvas.drawRect(Rect.fromLTWH(0, h / 3, w, h / 3), paint);
        paint.color = const Color(0xFFD52B1E);
        canvas.drawRect(Rect.fromLTWH(0, 2 * h / 3, w, h / 3), paint);
        break;

      case CountryFlag.uk:
        final bg = Paint()..color = const Color(0xFF012169);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bg);

        final whiteDiag = Paint()
          ..color = Colors.white
          ..strokeWidth = w * 0.16
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset.zero, Offset(w, h), whiteDiag);
        canvas.drawLine(Offset(w, 0), Offset(0, h), whiteDiag);

        final redDiag = Paint()
          ..color = const Color(0xFFC8102E)
          ..strokeWidth = w * 0.08
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset.zero, Offset(w, h), redDiag);
        canvas.drawLine(Offset(w, 0), Offset(0, h), redDiag);

        final whiteCross = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(w * 0.38, 0, w * 0.24, h), whiteCross);
        canvas.drawRect(Rect.fromLTWH(0, h * 0.38, w, h * 0.24), whiteCross);

        final redCross = Paint()..color = const Color(0xFFC8102E);
        canvas.drawRect(Rect.fromLTWH(w * 0.42, 0, w * 0.16, h), redCross);
        canvas.drawRect(Rect.fromLTWH(0, h * 0.42, w, h * 0.16), redCross);
        break;

      case CountryFlag.spain:
        final paint = Paint()..style = PaintingStyle.fill;
        paint.color = const Color(0xFFAD1519);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.25), paint);
        paint.color = const Color(0xFFFABD00);
        canvas.drawRect(Rect.fromLTWH(0, h * 0.25, w, h * 0.5), paint);
        paint.color = const Color(0xFFAD1519);
        canvas.drawRect(Rect.fromLTWH(0, h * 0.75, w, h * 0.25), paint);

        final emblem = Paint()..color = const Color(0xFFAD1519);
        canvas.drawCircle(Offset(w * 0.32, h * 0.5), h * 0.16, emblem);
        final innerEmblem = Paint()..color = const Color(0xFFFABD00);
        canvas.drawCircle(Offset(w * 0.32, h * 0.5), h * 0.08, innerEmblem);
        break;

      case CountryFlag.portugal:
        final paint = Paint()..style = PaintingStyle.fill;
        paint.color = const Color(0xFF006600);
        canvas.drawRect(Rect.fromLTWH(0, 0, w * 0.4, h), paint);
        paint.color = const Color(0xFFFF0000);
        canvas.drawRect(Rect.fromLTWH(w * 0.4, 0, w * 0.6, h), paint);

        final goldPaint = Paint()..color = const Color(0xFFFFCC00);
        canvas.drawCircle(Offset(w * 0.4, h * 0.5), w * 0.14, goldPaint);
        final innerShield = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(w * 0.4, h * 0.5), w * 0.08, innerShield);
        break;

      case CountryFlag.france:
        final paint = Paint()..style = PaintingStyle.fill;
        paint.color = const Color(0xFF002395);
        canvas.drawRect(Rect.fromLTWH(0, 0, w / 3, h), paint);
        paint.color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(w / 3, 0, w / 3, h), paint);
        paint.color = const Color(0xFFED2939);
        canvas.drawRect(Rect.fromLTWH(2 * w / 3, 0, w / 3, h), paint);
        break;

      case CountryFlag.italy:
        final paint = Paint()..style = PaintingStyle.fill;
        paint.color = const Color(0xFF009246);
        canvas.drawRect(Rect.fromLTWH(0, 0, w / 3, h), paint);
        paint.color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(w / 3, 0, w / 3, h), paint);
        paint.color = const Color(0xFFCE2B37);
        canvas.drawRect(Rect.fromLTWH(2 * w / 3, 0, w / 3, h), paint);
        break;

      case CountryFlag.japan:
        final paint = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
        paint.color = const Color(0xFFBC002D);
        canvas.drawCircle(Offset(w / 2, h / 2), h * 0.32, paint);
        break;

      case CountryFlag.korea:
        // South Korea: White background + Taegeuk + 4 trigrams
        final bgPaint = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

        // Center circle (Taegeuk)
        final center = Offset(w / 2, h / 2);
        final r = h * 0.28;

        final redPaint = Paint()..color = const Color(0xFFCD2E3A);
        final bluePaint = Paint()..color = const Color(0xFF0047A0);

        // Red top, blue bottom
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: r),
          0,
          math.pi,
          true,
          bluePaint,
        );
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: r),
          math.pi,
          math.pi,
          true,
          redPaint,
        );

        // Taegeuk curve lobes
        canvas.drawCircle(Offset(center.dx - r / 2, center.dy), r / 2, redPaint);
        canvas.drawCircle(Offset(center.dx + r / 2, center.dy), r / 2, bluePaint);

        // 4 corner trigram dots/bars
        final trigramPaint = Paint()
          ..color = const Color(0xFF111111)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;

        // Draw small corner accent lines
        canvas.drawLine(Offset(w * 0.16, h * 0.24), Offset(w * 0.26, h * 0.32), trigramPaint);
        canvas.drawLine(Offset(w * 0.74, h * 0.24), Offset(w * 0.84, h * 0.32), trigramPaint);
        canvas.drawLine(Offset(w * 0.16, h * 0.76), Offset(w * 0.26, h * 0.68), trigramPaint);
        canvas.drawLine(Offset(w * 0.74, h * 0.76), Offset(w * 0.84, h * 0.68), trigramPaint);
        break;

      case CountryFlag.bengali:
        // Bangladesh: Bottle green background + Red disc slightly offset to left
        final bgPaint = Paint()..color = const Color(0xFF006A4E);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);
        final redPaint = Paint()..color = const Color(0xFFF42A41);
        canvas.drawCircle(Offset(w * 0.45, h * 0.5), h * 0.33, redPaint);
        break;

      case CountryFlag.arabic:
        // Saudi Arabia / Arabic: Deep green background + white calligraphy emblem
        final bgPaint = Paint()..color = const Color(0xFF006C35);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

        final emblemPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        // Stylized sword line and text bar
        canvas.drawLine(Offset(w * 0.25, h * 0.58), Offset(w * 0.75, h * 0.58), emblemPaint);
        canvas.drawLine(Offset(w * 0.28, h * 0.58), Offset(w * 0.32, h * 0.44), emblemPaint);

        final textPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(w * 0.30, h * 0.40), Offset(w * 0.70, h * 0.40), textPaint);
        break;

      case CountryFlag.ukraine:
        final bluePaint = Paint()..color = const Color(0xFF0057B7);
        final yellowPaint = Paint()..color = const Color(0xFFFFD700);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h / 2), bluePaint);
        canvas.drawRect(Rect.fromLTWH(0, h / 2, w, h / 2), yellowPaint);
        break;

      case CountryFlag.indonesia:
        final redPaint = Paint()..color = const Color(0xFFFF0000);
        final whitePaint = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h / 2), redPaint);
        canvas.drawRect(Rect.fromLTWH(0, h / 2, w, h / 2), whitePaint);
        break;

      case CountryFlag.turkey:
        final redPaint = Paint()..color = const Color(0xFFE30A17);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), redPaint);

        final whitePaint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(w * 0.44, h * 0.5), h * 0.3, whitePaint);
        canvas.drawCircle(Offset(w * 0.49, h * 0.5), h * 0.24, redPaint);

        canvas.drawCircle(Offset(w * 0.68, h * 0.5), h * 0.1, whitePaint);
        break;

      case CountryFlag.china:
        final redPaint = Paint()..color = const Color(0xFFDE2910);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), redPaint);

        final starPaint = Paint()..color = const Color(0xFFFFDE00);
        canvas.drawCircle(Offset(w * 0.24, h * 0.32), h * 0.16, starPaint);
        canvas.drawCircle(Offset(w * 0.44, h * 0.18), h * 0.05, starPaint);
        canvas.drawCircle(Offset(w * 0.52, h * 0.28), h * 0.05, starPaint);
        canvas.drawCircle(Offset(w * 0.52, h * 0.44), h * 0.05, starPaint);
        canvas.drawCircle(Offset(w * 0.44, h * 0.54), h * 0.05, starPaint);
        break;

      case CountryFlag.poland:
        final whitePaint = Paint()..color = Colors.white;
        final redPaint = Paint()..color = const Color(0xFFDC143C);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h / 2), whitePaint);
        canvas.drawRect(Rect.fromLTWH(0, h / 2, w, h / 2), redPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _FlagPainter oldDelegate) => oldDelegate.flag != flag;
}
