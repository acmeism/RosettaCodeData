int divisorCount(int n) {
  int total = 1;
  // Deal with powers of 2 first
  for (; (n & 1) == 0; n >>= 1) total++;
  // Odd prime factors up to the square root
  for (int p = 3; p * p <= n; p += 2) {
    int count = 1;
    for (; n % p == 0; n ~/= p) count++;
    total *= count;
  }
  // If n > 1 then it's prime
  if (n > 1) total *= 2;
  return total;
}

void main() {
  const int limit = 100;
  print("Count of divisors for the first $limit positive integers:");
  for (int n = 1; n <= limit; ++n) {
    print(divisorCount(n).toString().padLeft(3));
  }
}
