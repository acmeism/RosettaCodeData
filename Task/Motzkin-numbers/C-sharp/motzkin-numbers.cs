using System;
using BI = System.Numerics.BigInteger;

class Program {

  // has multiple factors (other than 1 and x)
  static bool hmf(BI x) {
    if (x < 4) return x == 1;
    if ((x & 1) == 0 || x % 3 == 0) return true;
    int l = (int)Math.Sqrt((double)x); // this limit works because the 40th to 80th Motzkin numbers have factors of 2 or 3
    for (int j = 5, d = 4; j <= l; j += d = 6 - d)
      if (x % j == 0) return x > j;
    return false;
  }

  static void Main(string[] args) {
    BI a = 0, b = 1, t;
    int n = 1, s = 0, d = 1, c = 0, f = 1;
    while (n <= 80)
      Console.WriteLine("{0,46:n0} {1}",
        t = b / n++,
        hmf(t) ? "" : "is prime.",
        t = b,
        b = ((c += d * 3 + 3) * a +
             (f += d * 2 + 3) * b) /
             (s += d += 2),
        a = t);
  }
}
