function josephus(n: number, k: number): number {
  if (!n) {
    return 1;
  }

  return ((josephus(n - 1, k) + k - 1) % n) + 1;
}
