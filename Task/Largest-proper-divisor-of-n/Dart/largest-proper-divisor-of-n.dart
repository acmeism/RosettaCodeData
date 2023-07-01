import "dart:io";

num largest_proper_divisor(int n) {
  assert(n > 0);
  if ((n & 1) == 0) return n >> 1;
  for (int p = 3; p * p <= n; p += 2) {
    if (n % p == 0) return n / p;
  }
  return 1;
}

void main() {
  print("El mayor divisor propio de n es:");
  for (int n = 1; n < 101; ++n) {
    stdout.write(largest_proper_divisor(n));
    print(largest_proper_divisor(n) + n % 10 == 0 ? "\n" : " ");
  }
}
