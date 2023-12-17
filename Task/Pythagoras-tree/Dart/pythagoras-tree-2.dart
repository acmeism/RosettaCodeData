import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => FittedBox(
      child: CustomPaint(painter: TreePainter(), size: const Size(2400, 1600)));
}

class TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = Colors.white;
    final fill = Paint()..style = PaintingStyle.fill;
    canvas.drawColor(Colors.white, BlendMode.src);

    const halfBase = Offset(200, 0);
    var basis = [(size.bottomCenter(-halfBase), size.bottomCenter(halfBase))];
    for (var lvl = 0; lvl < 12; lvl++) {
      final path = Path();
      final basis0 = basis;
      basis = [];
      for (var (a, b) in basis0) {
        final v = Offset((b - a).dy, (a - b).dx);
        final (c, d) = (a + v, b + v);
        final e = (c + d + v) / 2;
        basis.addAll([(c, e), (e, d)]);
        path.addPolygon([a, c, e, d, c, d, b], true);
      }
      rg(int step) => (80 + (lvl - 2) * step) & 255;
      canvas
        ..drawPath(path, fill..color = Color.fromARGB(255, rg(20), rg(30), 18))
        ..drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
