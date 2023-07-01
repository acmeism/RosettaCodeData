struct Fraction {
  public long d;
  public long n;
}

Fraction rat_approx(double f, long md) {
  long a;
  long[] h = {0, 1, 0};
  long[] k = {1, 0, 0};
  long x, d, n = 1;
  bool neg = false;
  if (md <= 1) return {1, (long)f};
  if (f < 0) {
    neg = true;
    f = -f;
  }
  while (f != Math.floor(f)) {
    n <<= 1;
    f *= 2;
  }
  d = (long)f;
  for (int i = 0; i < 64; i++) {
    a = (n != 0) ? d / n : 0;
    if (i != 0 && a == 0) break;
    x = d; d = n; n = x %n;
    x = a;
    if (k[1] * a + k[0] >= md) {
      x = (md - k[0]) / k[1];
      if (x * 2 >= a || k[1] >= md)
        i = 65;
      else
        break;
    }
    h[2] = x * h[1] + h[0]; h[0] = h[1]; h[1] = h[2];
    k[2] = x * k[1] + k[0]; k[0] = k[1]; k[1] = k[2];
  }
  return {k[1], neg ? -h[1] : h[1]};
}

void main() {
  double f;

  print("f = %16.14f\n", f = 1.0/7);
  for (int i = 1; i < 20000000; i *= 16) {
    print("denom <= %11d: ", i);
    var r = rat_approx(f, i);
    print("%11ld/%ld\n", r.n, r.d);
  }

  print("f = %16.14f\n", f = Math.atan2(1,1) * 4);
  for (int i = 1; i < 20000000; i *= 16) {
    print("denom <= %11d: ", i);
    var r = rat_approx(f, i);
    print("%11ld/%ld\n", r.n, r.d);
  }
}
