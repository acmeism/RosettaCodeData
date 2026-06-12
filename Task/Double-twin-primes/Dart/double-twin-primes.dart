import 'dart:math';

void main() {
  for (int num = 3; num < 992; num += 2) {
    if (isPrime(num) &&
        isPrime(num + 2) &&
        isPrime(num + 6) &&
        isPrime(num + 8)) {
      print("$num ${num + 2} ${num + 6} ${num + 8}");
    }
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
