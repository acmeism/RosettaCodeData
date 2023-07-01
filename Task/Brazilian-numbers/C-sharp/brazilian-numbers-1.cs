using System;
class Program {

  static bool sameDigits(int n, int b) {
    int f = n % b;
    while ((n /= b) > 0) if (n % b != f) return false;
    return true;
  }

  static bool isBrazilian(int n) {
    if (n < 7) return false;
    if (n % 2 == 0) return true;
    for (int b = 2; b < n - 1; b++) if (sameDigits(n, b)) return true;
    return false;
  }

  static bool isPrime(int n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    int d = 5;
    while (d * d <= n) {
      if (n % d == 0) return false; d += 2;
      if (n % d == 0) return false; d += 4;
    }
    return true;
  }

  static void Main(string[] args) {
    foreach (string kind in ",odd ,prime ".Split(',')) {
      bool quiet = false; int BigLim = 99999, limit = 20;
      Console.WriteLine("First {0} {1}Brazilian numbers:", limit, kind);
      int c = 0, n = 7;
      while (c < BigLim) {
        if (isBrazilian(n)) {
          if (!quiet) Console.Write("{0:n0} ", n);
          if (++c == limit) { Console.Write("\n\n"); quiet = true; }
        }
        if (quiet && kind != "") continue;
        switch (kind) {
          case "": n++; break;
          case "odd ": n += 2; break;
          case "prime ":
            while (true) {
              n += 2;
              if (isPrime(n)) break;
            } break;
        }
      }
      if (kind == "") Console.WriteLine("The {0:n0}th Brazilian number is: {1:n0}\n", BigLim + 1, n);
    }
  }
}
