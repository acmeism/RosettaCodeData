bool is_prime(int n) {
  var d = 5;
  if (n < 2) return false;
  if (n % 2 == 0) return n == 2;
  if (n % 3 == 0) return n == 3;
  while (d * d <= n) {
    if (n % d == 0) return false;
    d += 2;
    if (n % d == 0) return false;
    d += 4;
  }
  return true;
}

int count_prime_factors(int n) {
  var count = 0;
  var f = 2;
  if (n == 1) return 0;
  if (is_prime(n)) return 1;
  while (true) {
    if (n % f == 0) {
      count++;
      n /= f;
      if (n == 1) return count;
      if (is_prime(n)) f = n;
    } else if (f >= 3) {
      f += 2;
    } else {
      f = 3;
    }
  }
}

void main() {
  const int MAX = 120;
  var n = 0;
  var count = 0;
  stdout.printf(@"The attractive numbers up to and including $MAX are:\n");
  for (int i = 1; i <= MAX; i++) {
    n = count_prime_factors(i);
    if (is_prime(n)) {
      stdout.printf("%4d", i);
      count++;
      if (count % 20 == 0)
        stdout.printf("\n");
    }
  }
  stdout.printf("\n");
}
