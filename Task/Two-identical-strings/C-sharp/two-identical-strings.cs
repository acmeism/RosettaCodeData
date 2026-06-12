using System; using static System.Console;
class Program { static void Main() { int c = 0, lmt = 1000;
    for (int n = 1, p = 2, k; n <= lmt; n++)
      if ((k = n + n * (p += n >= p ? p : 0)) > lmt) break;
      else Console.Write("{0,3} ({1,-10})  {2}", k,
          Convert.ToString(k, 2), ++c % 5 == 0 ? "\n" : "");
    Write("\nFound {0} numbers whose base 2 representation is the " +
      "concatenation of two identical binary strings.", c); } }
