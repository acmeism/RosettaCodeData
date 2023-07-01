public static double nthroot(int n, double x) {
  assert (n > 1 && x > 0);
  int np = n - 1;
  double g1 = x;
  double g2 = iter(g1, np, n, x);
  while (g1 != g2) {
    g1 = iter(g1, np, n, x);
    g2 = iter(iter(g2, np, n, x), np, n, x);
  }
  return g1;
}

private static double iter(double g, int np, int n, double x) {
  return (np * g + x / Math.pow(g, np)) / n;
}
