using System;

class Program {

  static void Main(string[] args) {
    var sw = System.Diagnostics.Stopwatch.StartNew();
    int a, b, c, i, n, s3, ab; var res = new int[65];
    for (n = 1, i = 0; n < 1850; n++) {
      bool found = true;
      for (a = 1; a < n; a++)
         for (b = a + 1, ab = a * b + a + b; b < n; b++, ab += a + 1) {
            if (ab > n) break;
            for (c = b + 1, s3 = ab + (b + a) * b; c < n; c++, s3 += b + a) {
                if (s3 == n) found = false;
                if (s3 >= n) break;
            }
         }
      if (found) res[i++] = n;
    }
    sw.Stop();
    Console.WriteLine("The 65 known Idoneal numbers:");
    for (i = 0; i < res.Length; i++)
      Console.Write("{0,5}{1}", res[i], i % 13 == 12 ? "\n" : "");
    Console.Write("Calculations took {0} ms", sw.Elapsed.TotalMilliseconds);
  }
}
