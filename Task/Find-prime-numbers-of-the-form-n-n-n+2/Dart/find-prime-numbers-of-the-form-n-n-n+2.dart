import 'dart:math';

void main() {
  for (var n = 1; n < 201; n++) {
    if (isPrime(pow(n, 3) + 2)) {
       print('$n \t ${pow(n, 3) + 2}');
    }
  }
}

bool isPrime(var n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  for (int i = 2; i <= sqrt(n); ++i) {
    if (n % i == 0) return false;
  }
  return true;
}
