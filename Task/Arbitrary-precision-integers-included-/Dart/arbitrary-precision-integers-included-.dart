import 'dart:math' show pow;

int fallingPowers(int base) =>
    base == 1 ? 1 : pow(base, fallingPowers(base - 1));

void main() {
  final exponent = fallingPowers(4),
      s = BigInt.from(5).pow(exponent).toString();
  print('First twenty:     ${s.substring(0, 20)}');
  print('Last twenty:      ${s.substring(s.length - 20)}');
  print('Number of digits: ${s.length}');
