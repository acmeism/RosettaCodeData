import 'dart:io';

final numDoors = 100;
final List<bool> doorClosed = List(numDoors);

String stateToString(String message) {
  var res = '';
  for (var i = 0; i < numDoors; i++) {
    res += (doorClosed[i] ? 'X' : '\u2610');
  }
  return res + " " + message;
}

main() {
  for (var i = 0; i < numDoors; i++) {
    doorClosed[i] = true;
  }
  stdout.writeln(stateToString("after initialization"));
  for (var step = 1; step <= numDoors; step++) {
    final start = step - 1;
    for (var i = start; i < numDoors; i += step) {
      doorClosed[i] = !doorClosed[i];
    }
    stdout.writeln(stateToString("after toggling with step = $step"));
  }
}
