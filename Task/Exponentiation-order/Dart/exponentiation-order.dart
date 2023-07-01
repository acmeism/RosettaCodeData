import 'dart:math' show pow;

void main() {
  print('(5 ^ 3) ^ 2 = ${pow(pow(5, 3), 2)}');
  print('5 ^ (3 ^ 2) = ${pow(5, (pow(3, 2)))}');
}
