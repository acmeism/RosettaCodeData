import 'package:more/more.dart';

main() {
  var size = 10;
  List<List<List<int>>> sq = List.generate(
      size, (i) => List.generate(size, (i) => 0.to(size).toList()));

  while (!done(sq)) {
    sq = next(sq);
  }
  sq.forEach(print);
}

done(List<List<List<int>>> sq) {
  for (var r in 0.to(sq.length)) {
    for (var c in 0.to(sq.first.length)) {
      if (sq[r][c].length != 1) return false;
    }
  }
  return true;
}

next(List<List<List<int>>> sq) {
  var min = 9999;
  var place = [-1, -1];
  for (var r in 0.to(sq.length)) {
    for (var c in 0.to(sq.first.length)) {
      var l = sq[r][c].length;
      if (l > 1 && l < min) {
        min = l;
        place = [r, c];
      }
    }
  }
  var val = sq[place.first][place.last].atRandom();
  set(sq, place.first, place.last, val);
  return sq;
}

set(List<List<List<int>>> sq, r, c, val) {
  if (sq[r][c] == [val]) return;
  sq[r][c] = [val];
  for (var cc in 0.to(sq.length)) {
    if (cc == c) continue;
    remove(sq, r, cc, val);
  }
  for (var rr in 0.to(sq.first.length)) {
    if (rr == r) continue;
    remove(sq, rr, c, val);
  }
}

remove(List<List<List<int>>> sq, r, c, val) {
  if (sq[r][c].length == 1) return;
  sq[r][c].remove(val);
  if (sq[r][c].length == 1) {
    set(sq, r, c, sq[r][c].first);
  }
}
