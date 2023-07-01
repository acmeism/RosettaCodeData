using System;
using System.Collections.Generic;
using BI = System.Numerics.BigInteger;

class Program
{
    // A sparse array of values calculated along the way
    static SortedList<int, BI> sl = new SortedList<int, BI>();

    // This routine is semi-recursive, but doesn't need to evaluate every number up to n.
    // Algorithm from here: http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Fibonacci/fibFormula.html#section3
    static BI Fsl(int n)
    {
        if (n < 2) return n;
        int n2 = n >> 1, pm = n2 + ((n & 1) << 1) - 1; IfNec(n2); IfNec(pm);
        return n2 > pm ? (2 * sl[pm] + sl[n2]) * sl[n2] : sqr(sl[n2]) + sqr(sl[pm]);
        // Helper routine for Fsl(). It adds an entry to the sorted list when necessary
        void IfNec(int x) { if (!sl.ContainsKey(x)) sl.Add(x, Fsl(x)); }
        // Helper function to square a BigInteger
        BI sqr(BI x) { return x * x; }
    }

    // Conventional iteration method (not used here)
    public static BI Fm(BI n)
    {
        if (n < 2) return n; BI cur = 0, pre = 1;
        for (int i = 0; i <= n - 1; i++) { BI sum = cur + pre; pre = cur; cur = sum; }
        return cur;
    }

    public static void Main()
    {
        int num = 2_000_000, digs = 35, vlen;
        var sw = System.Diagnostics.Stopwatch.StartNew(); var v = Fsl(num); sw.Stop();
        Console.Write("{0:n3} ms to calculate the {1:n0}th Fibonacci number, ",
          sw.Elapsed.TotalMilliseconds, num);
        Console.WriteLine("number of digits is {0}", vlen = (int)Math.Ceiling(BI.Log10(v)));
        if (vlen < 10000) {
            sw.Restart(); Console.WriteLine(v); sw.Stop();
            Console.WriteLine("{0:n3} ms to write it to the console.", sw.Elapsed.TotalMilliseconds);
        } else
            Console.Write("partial: {0}...{1}", v / BI.Pow(10, vlen - digs), v % BI.Pow(10, digs));
    }
}
