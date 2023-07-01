import 'dart:math';

void main() {
  const limit = 500;
  print('Additive primes less than $limit :');
  int count = 0;
  for (int n = 1; n < limit; ++n) {
    if (isPrime(digit_sum(n)) && isPrime(n)) {
      print('   $n');
      ++count;
    }
  }
  print('$count additive primes found.');
}

bool isPrime(int n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  for (int i = 2; i <= sqrt(n); ++i) {
    if (n % i == 0) return false;
  }
  return true;
}

int digit_sum(int n) {
  int sum = 0;
  for (int m = n; m > 0; m ~/= 10) sum += m % 10;
  return sum;
}
