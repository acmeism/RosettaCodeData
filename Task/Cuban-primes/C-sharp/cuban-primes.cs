using System;
using System.Collections.Generic;
using System.Linq;

static class Program
{
    static List<long> primes = new List<long>() { 3, 5 };

     static void Main(string[] args)
    {
        const int cutOff = 200;
        const int bigUn = 100000;
        const int chunks = 50;
        const int little = bigUn / chunks;
        const string tn = " cuban prime";
        Console.WriteLine("The first {0:n0}{1}s:", cutOff, tn);
        int c = 0;
        bool showEach = true;
        long u = 0, v = 1;
        DateTime st = DateTime.Now;
        for (long i = 1; i <= long.MaxValue; i++)
        {
            bool found = false;
            int mx = System.Convert.ToInt32(Math.Ceiling(Math.Sqrt(v += (u += 6))));
            foreach (long item in primes)
            {
                if (item > mx) break;
                if (v % item == 0) { found = true; break; }
            }
            if (!found)
            {
                c += 1; if (showEach)
                {
                    for (var z = primes.Last() + 2; z <= v - 2; z += 2)
                    {
                        bool fnd = false;
                        foreach (long item in primes)
                        {
                            if (item > mx) break;
                            if (z % item == 0) { fnd = true; break; }
                        }
                        if (!fnd) primes.Add(z);
                    }
                    primes.Add(v); Console.Write("{0,11:n0}", v);
                    if (c % 10 == 0) Console.WriteLine();
                    if (c == cutOff)
                    {
                        showEach = false;
                        Console.Write("\nProgress to the {0:n0}th{1}: ", bigUn, tn);
                    }
                }
                if (c % little == 0) { Console.Write("."); if (c == bigUn) break; }
            }
        }
        Console.WriteLine("\nThe {1:n0}th{2} is {0,17:n0}", v, c, tn);
        Console.WriteLine("Computation time was {0} seconds", (DateTime.Now - st).TotalSeconds);
        if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
    }
}
