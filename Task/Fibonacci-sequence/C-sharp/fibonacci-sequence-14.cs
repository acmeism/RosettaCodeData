using System;
using BI = System.Numerics.BigInteger;

class Program {

  // returns the nth Fibonacci number without calculating 0..n-1
  static BI oneFib(int n) {
    BI z = (BI)1 << ++n;
    return BI.ModPow(z, n, (z << n) - z - 1) % z;
  }

  // returns an array of Fibonacci numbers from the 0th to the nth
  static BI[] fibTab(int n) {
    var res = new BI[++n];
    BI z = (BI)1 << 1, zz = z << 1;
    for (int i = 0; i < n; ) {
      res[i] = BI.ModPow(z, ++i, zz - z - 1) % z;
      z <<= 1; zz <<= 2;
    }
    return res;
  }

  static void Main(string[] args) {
    int n = 20;
    Console.WriteLine("Fibonacci numbers 0..{0}: {1}", n, string.Join(" ",fibTab(n)));
    n = 1000;
    Console.WriteLine("Fibonacci({0}): {1}", n, oneFib(n));
  }
}
