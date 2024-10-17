import 'dart:math';

void main() {
  for (int x1 = 1; x1 < 1000000; x1++) {
    int x = pow(x1, 2).toInt();
    int i = 0;
    while (true) {
      int z = pow(10, i).toInt();
      if (x % z == x) break;
      i++;
    }

    if (i % 2 == 0) {
      int y = pow(10, i ~/ 2).toInt();
      int l = x % y;
      double o = x / y;
      o = o - l / y;
      double o3 = o;

      for (int j = 0; j < 4; j++) {
        if (o % 10 == 0) {
          o = o / 10;
        } else {
          break;
        }
      }

      if (o + l == x1 || o3 + l == x1) {
        print('$x1');
      }
    } else {
      int y1 = pow(10, (i + 1) ~/ 2).toInt();
      int l1 = x % y1;
      double o1 = x / y1;
      o1 = o1 - l1 / y1;
      double o2 = o1;

      for (int j = 0; j < 4; j++) {
        if (o1 % 10 == 0) {
          o1 = o1 / 10;
        } else {
          break;
        }
      }

      if (o1 + l1 == x1 || o2 + l1 == x1) {
        print('$x1');
      }
    }
  }
}
