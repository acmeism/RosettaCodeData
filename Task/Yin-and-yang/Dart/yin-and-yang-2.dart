import 'dart:math';
import 'package:flutter/material.dart';

Path yinYang(double r, double x, double y, [double th = 1.0]) {
  cR(double dY, double radius) => Rect.fromCircle(center: Offset(x, y + dY), radius: radius);
  return Path()
    ..fillType = PathFillType.evenOdd
    ..addOval(cR(0, r + th))
    ..addOval(cR(r / 2, r / 6))
    ..addOval(cR(-r / 2, r / 6))
    ..addArc(cR(0, r), -pi / 2, -pi)
    ..addArc(cR(r / 2, r / 2), pi / 2, pi)
    ..addArc(cR(-r / 2, r / 2), pi / 2, -pi);
}

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: YinYangPainter());
}

class YinYangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    canvas
      ..drawColor(Colors.white, BlendMode.src)
      ..drawPath(yinYang(50.0, 60, 60), fill)
      ..drawPath(yinYang(20.0, 140, 30), fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
