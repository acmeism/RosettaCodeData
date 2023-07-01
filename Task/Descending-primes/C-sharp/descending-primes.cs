using System;

class Program {

  static bool ispr(uint n) {
    if ((n & 1) == 0 || n < 2) return n == 2;
    for (uint j = 3; j * j <= n; j += 2)
      if (n % j == 0) return false; return true; }

  static void Main(string[] args) {
    uint c = 0; int nc;
    var ps = new uint[]{ 1, 2, 3, 4, 5, 6, 7, 8, 9 };
    var nxt = new uint[128];
    while (true) {
      nc = 0;
      foreach (var a in ps) {
        if (ispr(a))
          Console.Write("{0,8}{1}", a, ++c % 5 == 0 ? "\n" : " ");
        for (uint b = a * 10, l = a % 10 + b++; b < l; b++)
          nxt[nc++] = b;
      }
      if (nc > 1) {
        Array.Resize (ref ps, nc); Array.Copy(nxt, ps, nc); }
      else break;
    }
    Console.WriteLine("\n{0} descending primes found", c);
  }
}
