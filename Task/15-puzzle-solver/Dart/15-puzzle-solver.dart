import 'package:collection/collection.dart';

typedef OffsetFunction = int Function(int a, int b);
Function eq = const ListEquality().equals;

/// Solve Random 15 Puzzles
class FifteenSolver {
  static const target = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
  static const trN = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3];
  static const tcN = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2];
  var pos0 = List.filled(100, 0);
  var moves = List.filled(100, 0);
  var dirs = List.filled(100, '');
  int step = 0, best = 0;
  var board = List.generate(100, (int i) => List.filled(16, 0));

  bool isFinished() {
    if (moves[step] < best) return nextMove();
    if (eq(board[step], target)) {
      print("Solution found in $step moves :${dirs.join('')}");
      return true;
    }
    return (moves[step] == best) ? nextMove() : false;
  }

  var passNumber = 0;

  /// Try all valid moves from here, but don't retrace your steps.
  /// Return true if a solution is found.
  bool nextMove() {
    // if (passNumber++ ~/ 100000 == 0) print("${dirs.join('')}");
    return (dirs[step] != 'u' && pos0[step] ~/ 4 < 3 && down()) ||
        (dirs[step] != 'd' && pos0[step] ~/ 4 > 0 && up()) ||
        (dirs[step] != 'l' && pos0[step] % 4 < 3 && right()) ||
        (dirs[step] != 'r' && pos0[step] % 4 > 0 && left()) ||
        false;
  }

  bool move(int offset, String dir, List<int> rcArray, OffsetFunction rcFunc) {
    final int ix = pos0[step] + offset;
    final n = board[step][ix];
    pos0[step + 1] = pos0[step] + offset;
    board[step + 1] = board[step].toList()
      ..[pos0[step]] = n
      ..[ix] = 0;
    dirs[step + 1] = dir;
    moves[step + 1] = moves[step] + rcFunc(rcArray[n], pos0[step]);
    step++;
    if (isFinished()) return true;
    step--;
    return false;
  }

  bool right() => move(1, 'r', tcN, (a, b) => (a <= b % 4 ? 0 : 1));
  bool left() => move(-1, 'l', tcN, (a, b) => (a >= b % 4 ? 0 : 1));
  bool down() => move(4, 'd', trN, (a, b) => (a <= b ~/ 4 ? 0 : 1));
  bool up() => move(-4, 'u', trN, (a, b) => (a >= b ~/ 4 ? 0 : 1));

  void solve(List<int> initBoard) {
    pos0[0] = initBoard.indexOf(0);
    board[0] = initBoard;
    while (!isFinished()) best++;
  }
}

void main(List<String> args) {
  print("running");
  // test values
  // final start = [5, 1, 2, 3, 6, 10, 7, 4, 13, 9, 11, 8, 14, 0, 15, 12];
  // final start = [9, 1, 2, 4, 13, 6, 5, 7, 3, 11, 14, 15, 10, 0, 8, 12];
  // final start = [10, 3, 1, 4, 13, 5, 8, 7, 9, 6, 0, 11, 14, 15, 12, 2];
  // required solution
  final start = [15, 14, 1, 6, 9, 11, 4, 12, 0, 10, 7, 3, 13, 8, 5, 2];
  // Extra credit
  // final start = [0, 12, 9, 13, 15, 11, 10, 14, 3, 7, 2, 5, 4, 8, 6, 1];
  print(start);
  FifteenSolver().solve(start);
}
