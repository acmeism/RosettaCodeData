import 'dart:math';
import 'dart:io';

void main() {
  var basis = [(Point(-200.0, 0.0), Point(200.0, 0.0))];
  final groups = Iterable.generate(12, (lvl) {
    final basis0 = basis;
    basis = [];
    final lvlPolygons = basis0.map((pp) {
      final (a, b) = pp;
      final v =  Point((b - a).y, (a - b).x);
      final [c, d, e] = [a, b, (a + b + v) * 0.5].map((p) => p + v).toList();
      basis.addAll([(c, e), (e, d)]);
      return '<polygon points="${[a, c, e, d, c, d, b].expand((p) => [p.x, p.y]).join(' ')}"/>';
    }).join('\n');
    rg(int step) => ((80 + (lvl - 2) * step) & 255).toRadixString(16).padLeft(2, '0');
    return '<g fill="#${rg(20)}${rg(30)}18">\n$lvlPolygons\n</g>';
  }).join('\n');
  final (x, y) = basis.fold((0.0, 0.0), (p, pp) => (min(p.$1, pp.$1.x), min(p.$2, pp.$1.y)));
  final attrs = 'viewBox="$x $y ${-x - x} ${-y}" stroke="white" xmlns="http://www.w3.org/2000/svg"';
  File('Pythagor_tree.svg').writeAsString('<svg $attrs>\n$groups\n</svg>');
}
