import 'dart:math';
main() {
  var nuggets = List<int>.generate(101, (int index) => index);
  for (int small in List<int>.generate((100 ~/ (6 + 1)), (int index) => index)) {
    for (int medium in List<int>.generate((100 ~/ (9 + 1)), (int index) => index)) {
      for (int large in List<int>.generate((100 ~/ (20 + 1)), (int index) => index)) {
        nuggets.removeWhere((element) => element == 6 * small + 9 * medium + 20 * large);
      }
    }
  }
  print('Largest non-McNuggets number: ${nuggets.reduce(max).toString() ?? 'none'}.');
}
