import 'dart:math';

bool isPrime(var n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  for (var i = 2; i <= sqrt(n); i++) if (n % i == 0) return false;
  return true;
}

void main() {
  const double euler = 0.57721566490153286;

  double m = 0.0;
  for (var x = 2; x <= 1e8; x++)
    if (isPrime(x)) m += log(1 - (1 / x)) + (1 / x);

  print('MM = ${euler + m}');
}
