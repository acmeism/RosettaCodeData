import 'dart:math';
import 'package:more/more.dart';

void main(List<String> args) {
  var bd = board();
  while (isBad(bd)) bd = board();
  print(bd.map((e) => e.join(' ')).join('\n'));
}

board() {
  var Ps = "RNBQBNRPPPPPPPP";
  var s = ("kK$Ps" + Ps.toLowerCase()).take(Random().nextInt(27) + 5).toList();
  s = (s + List.filled(64, ".")).sublist(0, 64)..shuffle();
  return s.chunked(8).toList();
}

isBad(bd) {
  var p = (bd.first + bd.last).join('').toLowerCase().contains("p");
  var ks = [find(bd, 'k'), find(bd, 'K')];
  var d = max<int>((ks[0][0] - ks[1][0]).abs(), (ks[0][1] - ks[1][1]).abs());
  return (p || (d < 2));
}

find(List<List<String>> bd, c) {
  for (var r in bd.indexed()) {
    var i = r.value.indexOf(c);
    if (i >= 0) return ([r.index, i]);
  }
}
