import 'dart:math';

void main() {
  final array = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'];
  int i;

  for (i = 1; i < 30; i++) {
    var intValue = Random().nextInt(i) % 10;
    print(array[intValue]);
  }
}
