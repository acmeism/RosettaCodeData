import 'dart:core';

void main() {
  for (int i = 0; i < 8; ++i) {
    final ones = int.parse('1' * i + '3');
    print('${ones.toString().padLeft(9)}^2 = ${ones * ones}');
  }
}
