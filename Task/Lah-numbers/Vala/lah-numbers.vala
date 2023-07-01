uint64 factorial(uint8 n) {
  uint64 res = 1;
  if (n == 0) return res;
  while (n > 0) res *= n--;
  return res;
}

uint64 lah(uint8 n, uint8 k) {
  if (k == 1) return factorial(n);
  if (k == n) return 1;
  if (k > n)  return 0;
  if (k < 1 || n < 1) return 0;
  return (factorial(n) * factorial(n - 1)) / (factorial(k) * factorial(k - 1)) / factorial(n - k);
}

void main() {
  uint8 row, i;

  print("Unsigned Lah numbers: L(n, k):\n");
  print("n/k ");
  for (i = 0; i < 13; i++) {
   print("%10d ", i);
  }
  print("\n");
  for (row = 0; row < 13; row++) {
    print("%-3d", row);
    for (i = 0; i < row + 1; i++) {
      uint64 l = lah(row, i);
      print("%11lld", l);
    }
    print("\n");
  }
}
