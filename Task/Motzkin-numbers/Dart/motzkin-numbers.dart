import 'dart:math';

void main() {
  var M = List<int>.filled(42, 1);
  M[0] = 1;
  M[1] = 1;
  print('1');
  print('1');
  for (int n = 2; n < 42; ++n) {
    M[n] = M[n - 1];
    for (int i = 0; i <= n - 2; ++i) {
      M[n] += M[i] * M[n - 2 - i];
    }
    if (isPrime(M[n])) {
      print('${M[n]}    is a prime');
    } else {
      print('${M[n]}');
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
