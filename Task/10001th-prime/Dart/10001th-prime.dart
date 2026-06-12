import 'dart:math';

bool isPrime(int n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  for (int i = 2; i <= sqrt(n); ++i) {
    if (n % i == 0) return false;
  }
  return true;
}

int prime(int n) {
  int p, pn = 1;
  if (n == 1) return 2;
  for (p = 3; pn < n; p += 2) {
    if (isPrime(p)) pn++;
  }
  return p - 2;
}

void main() {
  print(prime(10001));
}
