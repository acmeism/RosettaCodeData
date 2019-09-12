using System;
using System.Numerics;

class Program {

  const int MaxPow = 301;
  static int [] sq = {1, 4, 9, 16, 25, 36, 49, 64, 81};
  static BigInteger [] sums;

  static bool is89(int x) {
    while (true) {
      int s = 0, t;
      do if ((t = (x % 10) - 1) >= 0) s += sq[t]; while ((x /= 10) > 0);
      if (s == 89) return true;
      if (s == 1) return false;
      x = s;
    }
  }

  static BigInteger count89(int n) {
      BigInteger result = 0;
      for (int i = n * 81; i > 0; i--) {
        foreach (int s in sq) { if(s > i) break; sums[i] += sums[i - s]; }
        if (is89(i)) result += sums[i];
      }
      return result;
  }

  static void Main(string[] args) {
    BigInteger [] t = new BigInteger[2] {1, 0}; sums = new BigInteger[MaxPow * 81]; Array.Copy(t, sums, t.Length);
    DateTime st = DateTime.Now;
    for (int n = 1; n < MaxPow; n++) {
      Console.Write("1->10^{0,-3}: {1}\n", n, count89(n));
      if ((DateTime.Now - st).TotalSeconds > 6) break;
    }
    Console.WriteLine("{0} seconds elapsed.", (DateTime.Now - st).TotalSeconds);
  }
}
