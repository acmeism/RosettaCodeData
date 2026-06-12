import 'dart:math';
import 'dart:io';

void main() {
  int n = 0, p = 1;
  while (n < 22) {
    stdout.write("$n  ");
    ++p;
    if (isPrime(p))  ++n;
  }
}

bool isPrime(int n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  for (int i = 2; i <= sqrt(n); ++i) {
    if (n % i == 0) return false;
  }
  return true;
}
