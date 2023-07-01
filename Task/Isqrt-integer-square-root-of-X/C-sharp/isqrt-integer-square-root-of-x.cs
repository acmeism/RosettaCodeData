using System;
using static System.Console;
using BI = System.Numerics.BigInteger;
 
class Program {
 
    static BI isqrt(BI x) { BI q = 1, r = 0, t; while (q <= x) q <<= 2; while (q > 1) {
        q >>= 2; t = x - r - q; r >>= 1; if (t >= 0) { x = t; r += q; } } return r; }
 
    static void Main() { const int max = 73, smax = 65;
        int power_width = ((BI.Pow(7, max).ToString().Length / 3) << 2) + 3,
            isqrt_width = (power_width + 1) >> 1;
        WriteLine("Integer square root for numbers 0 to {0}:", smax);
        for (int n = 0; n <= smax; ++n) Write("{0} ",
            (n / 10).ToString().Replace("0", " ")); WriteLine();
        for (int n = 0; n <= smax; ++n) Write("{0} ", n % 10); WriteLine();
        WriteLine(new String('-', (smax << 1) + 1));
        for (int n = 0; n <= smax; ++n) Write("{0} ", isqrt(n));
        WriteLine("\n\nInteger square roots of odd powers of 7 from 1 to {0}:", max);
        string s = string.Format("[0,2] |[1,{0}:n0] |[2,{1}:n0]",
            power_width, isqrt_width).Replace("[", "{").Replace("]", "}");
        WriteLine(s, "n", "7 ^ n", "isqrt(7 ^ n)");
        WriteLine(new String('-', power_width + isqrt_width + 6));
        BI p = 7; for (int n = 1; n <= max; n += 2, p *= 49)
            WriteLine (s, n, p, isqrt(p)); }
}
