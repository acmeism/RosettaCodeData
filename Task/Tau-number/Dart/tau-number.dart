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
  print("The first $limit tau numbers are:");
  int count = 0;
  for (int n = 1; count < limit; n++) {
    if (n % divisorCount(n) == 0) {
      print(n.toString().padLeft(6));
      count++;
    }
  }
}
