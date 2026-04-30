import 'dart:io';
import 'package:more/more.dart';

var words = RegExp(r'^[a-z]*$');
const n8 = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0],
  [1, 1],
  [1, -1],
  [-1, 1],
  [-1, -1]
];

main() {
  var text = File('bin/_other/unixdict.txt')
      .readAsLinesSync()
      .where((e) => words.hasMatch(e))
      .where((e) => e.length > 2);

  var done = false;
  while (!done) {
    var square = List.generate(10, (e) => "..........".split(''));
    var used = <String>[];
    var starts = <List<int>>[];
    var ends = <List<int>>[];

    getNexts() => [
          for (var r in square.indexed())
            for (var c in r.value.indexed())
              if (c.value == '.') [r.index, c.index]
        ];
    var nexts = getNexts();
    while (nexts.length > 11) {
      // Pick a start and a direction, then fit longest allowed word or loop.
      var here = nexts.atRandom();
      var dir = n8.atRandom();
      var len = 1;
      var target = square[here.first][here.last];
      while (inBounds(
          [here.first + len * dir.first, here.last + len * dir.last])) {
        target +=
            square[here.first + len * dir.first][here.last + len * dir.last];
        len += 1;
      }
      if (len >= 7) continue; // Stop the grid getting too full.
      if (len <= 3) continue;
      var reg = RegExp('^$target\$');
      var cands = text.where((e) => reg.hasMatch(e));
      if (cands.isEmpty) continue;

      var cand = cands.atRandom();
      for (var i in 0.to(cand.length)) {
        square[here.first + i * dir.first][here.last + i * dir.last] = cand[i];
      }
      used.add(cand);
      starts.add(here);
      ends.add([
        here.first + (len - 1) * dir.first,
        here.last + (len - 1) * dir.last
      ]);
      nexts = getNexts();
    }
    if (nexts.length < 11) continue;
    if (used.length < 25) continue;
    var filler = 'ROSETTACODE'.split('');
    for (var n in nexts.indexed()) {
      square[n.value.first][n.value.last] = filler[n.index];
    }
    square.forEach(print);
    for (var i in 0.to(used.length)) {
      print('${used[i]}\t ${starts[i]}\t${ends[i]}');
    }
    done = true;
  }
}

inBounds(List<int> pos) => pos.first.between(0, 9) && pos.last.between(0, 9);
