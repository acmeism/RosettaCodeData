using System; using static System.Console;

class Program {

  static bool[] np; // not-prime array

  static void ms(long lmt) { // populates array, a not-prime is true
    np = new bool[lmt]; np[0] = np[1] = true;
    for (long n = 2, j = 1; n < lmt; n += j, j = 2) if (!np[n])
        for (long k = n * n; k < lmt; k += n) np[k] = true; }

  static bool is_Mag(long n) { long res, rem;
    for (long p = 10; n >= p; p *= 10) {
      res = Math.DivRem (n, p, out rem);
      if (np[res + rem]) return false; } return true; }

  static void Main(string[] args) { ms(100_009); string mn;
    WriteLine("First 45{0}", mn = " magnanimous numbers:");
    for (long l = 0, c = 0; c < 400; l++) if (is_Mag(l)) {
      if (c++ < 45 || (c > 240 && c <= 250) || c > 390)
        Write(c <= 45 ? "{0,4} " : "{0,8:n0} ", l);
      if (c < 45 && c % 15 == 0) WriteLine();
      if (c == 240) WriteLine ("\n\n241st through 250th{0}", mn);
      if (c == 390) WriteLine ("\n\n391st through 400th{0}", mn); } }
}
