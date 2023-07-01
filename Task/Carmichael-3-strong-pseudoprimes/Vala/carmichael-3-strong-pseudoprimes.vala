long mod(long n, long m) {
  return ((n % m) + m) % m;
}

bool is_prime(long n) {
  if (n == 2 || n == 3)
    return true;
  else if (n < 2 || n % 2 == 0 || n % 3 == 0)
    return false;
  for (long div = 5, inc = 2; div * div <= n;
    div += inc, inc = 6 - inc)
    if (n % div == 0)
      return false;
  return true;
}

void main() {
  for (long p = 2; p <= 63; p++) {
    if (!is_prime(p)) continue;
    for (long h3 = 2; h3 <= p; h3++) {
      var g = h3 + p;
      for (long d = 1; d <= g; d++) {
        if ((g * (p - 1)) % d != 0 || mod(-p * p, h3) != d % h3)
          continue;
        var q = 1 + (p - 1) * g / d;
        if (!is_prime(q)) continue;
        var r = 1 + (p * q / h3);
        if (!is_prime(r) || (q * r) % (p - 1) != 1) continue;
        stdout.printf("%5ld × %5ld × %5ld = %10ld\n", p, q, r, p * q * r);
      }
    }
  }
}
