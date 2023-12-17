/* Imports and Exports */
import 'dart:io';

/* Main Block */
int main() {
  yinYang(18);
  return 0;
}

/* Function Definitions */
bool circle(int x, int y, int c, int r) {
  return (r * r) >= ((x = x ~/ 2) * x) + ((y = y - c) * y);
}

String pixel(int x, int y, int r) {
  if (circle(x, y, -r ~/ 2, r ~/ 6)) {
    return '#';
  }
  if (circle(x, y, r ~/ 2, r ~/ 6)) {
    return '.';
  }
  if (circle(x, y, -r ~/ 2, r ~/ 2)) {
    return '.';
  }
  if (circle(x, y, r ~/ 2, r ~/ 2)) {
    return '#';
  }
  if (circle(x, y, 0, r)) {
    if (x < 0) {
      return '.';
    } else {
      return '#';
    }
  }
  return ' ';
}

void yinYang(int r) {
  for (int y = -r; y <= r; y++) {
    for (int x = -2 * r; x <= 2 * r; x++) {
      stdout.write(pixel(x, y, r));
    }
    stdout.write('\n');
  }
}
