import 'dart:math' show pow;

num nroot(num value, num degree) {
  return pow(value, (1 / degree));
}

void main() {
  int n = 15;
  num x = pow(-3.14159, 15);
  print('root($n, $x) = ${nroot(n, x)}');
}
