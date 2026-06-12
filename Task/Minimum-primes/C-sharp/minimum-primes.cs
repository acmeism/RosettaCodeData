using System;
using System.Linq;
using static System.Console;

class Program {

  static int nxtPrime(int x) {
    int j = 2; do {
        if (x % j == 0) { j = 2; x++; }
        else j += j < 3 ? 1 : 2;
    } while (j * j <= x); return x; }

  static void Main(string[] args) {
    WriteLine("working...");
    int[] Num1 = new int[]{  5, 45, 23, 21, 67 },
          Num2 = new int[]{ 43, 22, 78, 46, 38 },
          Num3 = new int[]{  9, 98, 12, 54, 53 };
    int n = Num1.Length; int[] Nums = new int[n];
    for (int i = 0; i < n; i++)
      Nums[i] = nxtPrime(new int[]{ Num1[i], Num2[i], Num3[i] }.Max());
    WriteLine("The minimum prime numbers of three lists = [{0}]", string.Join(",", Nums));
    Write("done..."); } }
