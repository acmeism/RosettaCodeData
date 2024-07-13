/// Based on https://rosettacode.org/wiki/Solve_a_Numbrix_puzzle#Kotlin
import 'package:more/more.dart';
import 'package:sprintf/sprintf.dart';

const examples = [
  [
    "00,00,00,00,00,00,00,00,00",
    "00,00,46,45,00,55,74,00,00",
    "00,38,00,00,43,00,00,78,00",
    "00,35,00,00,00,00,00,71,00",
    "00,00,33,00,00,00,59,00,00",
    "00,17,00,00,00,00,00,67,00",
    "00,18,00,00,11,00,00,64,00",
    "00,00,24,21,00,01,02,00,00",
    "00,00,00,00,00,00,00,00,00"
  ],
  [
    "00,00,00,00,00,00,00,00,00",
    "00,11,12,15,18,21,62,61,00",
    "00,06,00,00,00,00,00,60,00",
    "00,33,00,00,00,00,00,57,00",
    "00,32,00,00,00,00,00,56,00",
    "00,37,00,01,00,00,00,73,00",
    "00,38,00,00,00,00,00,72,00",
    "00,43,44,47,48,51,76,77,00",
    "00,00,00,00,00,00,00,00,00"
  ]
];

const moves = [
  [1, 0],
  [0, 1],
  [-1, 0],
  [0, -1]
];

late List<String> board;
late List<List<int>> grid;
late List<int> clues;
var totalToFill = 0;

bool solve(int r, int c, int count, int nextClue) {
  if (count > totalToFill) return true;
  var back = grid[r][c];
  if (back != 0 && back != count) return false;
  if (back == 0 && nextClue < clues.length && clues[nextClue] == count) {
    return false;
  }

  var nextClue2 = nextClue;
  if (back == count) nextClue2++;
  grid[r][c] = count;
  var res = moves.any((m) => solve(r + m[1], c + m[0], count + 1, nextClue2));
  if (!res) grid[r][c] = back;
  return res;
}

void printResult(int n) {
  print("Solution for example $n:");
  for (var row in grid) {
    print([
      for (var e in row)
        if (e != -1) sprintf("%2d ", [e])
    ].join());
  }
}

main() {
  for (var each in examples.indexed()) {
    board = each.value;
    var nRows = board.length + 2, nCols = board[0].split(",").length + 2;
    var startRow = 0, startCol = 0;
    grid = List.generate(nRows, (i) => List.filled(nCols, -1));
    totalToFill = (nRows - 2) * (nCols - 2);
    var lst = <int>[];
    for (var r in 1.to(nRows - 1)) {
      var row = board[r - 1].split(",");
      for (var c in 1.to(nCols - 1)) {
        var value = int.parse(row[c - 1]);
        if (value > 0) lst.add(value);
        if (value == 1) {
          startRow = r;
          startCol = c;
        }
        grid[r][c] = value;
      }
    }

    clues = (lst..sort()).toList();
    if (solve(startRow, startCol, 1, 0)) printResult(each.index + 1);
  }
}
