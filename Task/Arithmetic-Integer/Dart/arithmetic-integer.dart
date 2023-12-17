import 'dart:io';
import 'dart:math' show pow;

void main() {
  print('enter a integer: ');
  int a = int.parse(stdin.readLineSync());
  print('enter another integer: ');
  int b = int.parse(stdin.readLineSync());

  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a * b = ${a * b}');
  print('a / b = ${a ~/ b}');
  print('a % b = ${a % b}');
  print('a ^ b = ${pow(a, b)}');

  //Integer division uses the '~/' operator
}
