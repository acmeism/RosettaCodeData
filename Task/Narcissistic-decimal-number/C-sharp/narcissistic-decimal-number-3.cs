using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Numerics;

static class Program
{
    public static void nar(int max, bool only1 = false)
    {
        int n, n1, n2, n3, n4, n5, n6, n7, n8, n9;
        int[] d;                                       // digits tally
        char [] bs;                                    // BigInteger String
        List<BigInteger> res = new List<BigInteger>(); // per n digits results
        BigInteger[,] p = new BigInteger[10, max + 1]; // powers array

        // BigIntegers for intermediate results
        BigInteger x2, x3, x4, x5, x6, x7, x8, x9;

        for (n = only1 ? max : 1; n <= max; n++) // main loop
        {
            for (int i = 1; i <= 9; i++) // init powers array for this n
            {
                p[i, 1] = BigInteger.Pow(i, n);
                for (int j = 2; j <= n; j++) p[i, j] = p[i, 1] * j;
            }
            for (n9 = n; n9 >= 0; n9--) // nested loops...
            {
                x9 = p[9, n9];
                for (n8 = n - n9; n8 >= 0; n8--)
                {
                    x8 = x9 + p[8, n8];
                    for (n7 = n - n9 - n8; n7 >= 0; n7--)
                    {
                        x7 = x8 + p[7, n7];
                        for (n6 = n - n9 - n8 - n7; n6 >= 0; n6--)
                        {
                            x6 = x7 + p[6, n6];
                            for (n5 = n - n9 - n8 - n7 - n6; n5 >= 0; n5--)
                            {
                                x5 = x6 + p[5, n5];
                                for (n4 = n - n9 - n8 - n7 - n6 - n5; n4 >= 0; n4--)
                                {
                                    x4 = x5 + p[4, n4];
                                    for (n3 = n - n9 - n8 - n7 - n6 - n5 - n4; n3 >= 0; n3--)
                                    {
                                        x3 = x4 + p[3, n3];
                                        for (n2 = n - n9 - n8 - n7 - n6 - n5 - n4 - n3; n2 >= 0; n2--)
                                        {
                                            x2 = x3 + p[2, n2];
                                            for (n1 = n - n9 - n8 - n7 - n6 - n5 - n4 - n3 - n2; n1 >= 0; n1--)
                                            {
                                                bs = (x2 + n1).ToString().ToCharArray();
                                                switch (bs.Length.CompareTo(n))
                                                { // Since all the for/next loops step down, when the digit count
                                                  // becomes smaller than n, it's time to try the next n value.
                                                    case -1: { goto Next_n; }
                                                    case 0:
                                                        {
                                                            d = new int[10]; foreach (char c in bs) d[c - 48] += 1;
                                                            if (n9 == d[9] && n8 == d[8] && n7 == d[7] &&
                                                                n6 == d[6] && n5 == d[5] && n4 == d[4] &&
                                                                n3 == d[3] && n2 == d[2] && n1 == d[1] &&
                                                                n - n9 - n8 - n7 - n6 - n5 - n4 - n3 - n2 - n1 == d[0])
                                                                res.Add(BigInteger.Parse(new string(bs)));
                                                            break;
                                                        }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
Next_n:     if (only1) {
                Console.Write("{0} ", n); lock (resu) resu.AddRange(res); return;
            } else {
                res.Sort(); Console.WriteLine("{2,3} {0,3}: {1}",
                Math.Ceiling((DateTime.Now - st).TotalSeconds), string.Join(" ", res), n); res.Clear();
            }
        }
    }

    private static DateTime st = default(DateTime);
    private static List<BigInteger> resu = new List<BigInteger>();
    private static bool para = true; // parallel (default) or sequential calcualtion
    private static int lim = 7;  // this is the number of digits to calcualate, not the nth entry.
                                 // for up to the 25th item, use lim = 7 digits.
                                 // for all 89 items, use lim = 39 digits.
    public static void Main(string[] args)
    {
        if (args.Count() > 0)
        {
            int t = lim; int.TryParse(args[0], out t);
            if (t < 1) t = 1;   // number of digits must be > 0
            if (t > 61) t = 61; // no point when lim * math.pow(9, lim) < math.pow(10, lim - 1)
            lim = t;
            // default is parallel, will do sequential when any 2nd command line parameter is present.
            para = !(args.Count() > 1);
        }
        st = DateTime.Now;
        if (para)
        {
            Console.Write("Calculations in parallel... "); // starts the bigger ones first
            Parallel.ForEach(Enumerable.Range(1, lim).Reverse().ToArray(), n => { nar(n, true); } );
            resu.Sort(); int[] g = Enumerable.Range(1, resu.Count).ToArray();
            var both = g.Zip(resu, (a, b) => a.ToString() + " " + b.ToString());
            Console.WriteLine("\n{0}", string.Join("\n", both));
        }
        else { Console.WriteLine("Sequential calculations:"); nar(lim); }
        Console.WriteLine("Total elasped: {0} seconds", (DateTime.Now - st).TotalSeconds);
        if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
    }
}
