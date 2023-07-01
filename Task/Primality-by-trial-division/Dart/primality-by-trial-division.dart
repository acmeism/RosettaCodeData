import 'dart:math';

bool isPrime(int n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  for (int i = 2; i <= sqrt(n); ++i) if (n % i == 0) return false;
  return true;
}

void main() {
  for (int i = 1; i <= 99; ++i) if (isPrime(i)) print('$i ');
}
