double map_range(double[] a, double[] b, double s) {
  return b[0] + ((s - a[0]) * (b[1] - b[0]) / (a[1] - a[0]));
}

void main() {
  const double[] r1 = {0.0, 10.0};
  const double[] r2 = {-1.0, 0.0};
  for (int s = 0; s < 11; s++)
    print("%2d maps to %5.2f\n", s, map_range(r1, r2, (double)s));
}
