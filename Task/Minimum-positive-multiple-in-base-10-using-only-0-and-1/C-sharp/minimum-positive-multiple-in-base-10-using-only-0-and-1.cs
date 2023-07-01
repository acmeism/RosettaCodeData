using System;
using System.Collections.Generic;
using static System.Console;

class Program {

  static string B10(int n) {
    int[] pow = new int[n + 1], val = new int[29];
    for (int count = 0, ten = 1, x = 1; x <= n; x++) {
      val[x] = ten;
      for (int j = 0, t; j <= n; j++)
        if (pow[j] != 0 && pow[j] != x && pow[t = (j + ten) % n] == 0)
          pow[t] = x;
      if (pow[ten] == 0) pow[ten] = x;
      ten = (10 * ten) % n;
      if (pow[0] != 0) {
        x = n;
        string s = "";
        while (x != 0) {
          int p = pow[x % n];
          if (count > p) s += new string('0', count - p);
          count = p - 1;
          s += "1";
          x = (n + x - val[p]) % n;
        }
        if (count > 0) s += new string('0', count);
        return s;
      }
    }
    return "1";
  }

  static void Main(string[] args) {
    string fmt = "{0,4} * {1,24} = {2,-28}\n";
    int[] m = new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
      95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105,
      297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878 };
    string[] r = new string[m.Length];
    WriteLine(fmt + new string('-', 62), "n", "multiplier", "B10");
    var sw = System.Diagnostics.Stopwatch.StartNew();
    for (int i = 0; i < m.Length; i++) r[i] = B10(m[i]);
    sw.Stop();
    for (int i = 0; i < m.Length; i++) Write(fmt, m[i], decimal.Parse(r[i]) / m[i], r[i]);
    Write("\nTook {0}ms", sw.Elapsed.TotalMilliseconds);
  }
}
