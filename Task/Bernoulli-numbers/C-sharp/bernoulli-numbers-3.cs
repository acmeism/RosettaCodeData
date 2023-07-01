using System;
using System.Numerics;
using System.Collections.Generic;

namespace bern
{
    class Program
    {
        struct BerNum { public int index; public BigInteger Numer, Denomin; };
        static int w1 = 1, w2 = 1; // widths for formatting output
        static int max = 60; // default maximum, can override on command line

        // returns nth Bernoulli number
        static BerNum CalcBernoulli(int n)
        {
            BerNum res;
            BigInteger f;
            BigInteger[] nu = new BigInteger[n + 1],
                         de = new BigInteger[n + 1];
            for (int m = 0; m <= n; m++)
            {
                nu[m] = 1; de[m] = m + 1;
                for (int j = m; j > 0; j--)
                    if ((f = BigInteger.GreatestCommonDivisor(
                        nu[j - 1] = j * (de[j] * nu[j - 1] - de[j - 1] * nu[j]),
                        de[j - 1] *= de[j])) != BigInteger.One)
                    { nu[j - 1] /= f; de[j - 1] /= f; }
            }
            res.index = n; res.Numer = nu[0]; res.Denomin = de[0];
            w1 = Math.Max(n.ToString().Length, w1);             // ratchet up widths
            w2 = Math.Max(res.Numer.ToString().Length, w2);
            if (max > 50) Console.Write("."); // progress dots appear for larger values
            return res;
        }

        static void Main(string[] args)
        {
            List<BerNum> BNumbList = new List<BerNum>();
            // defaults to 60 when no (or invalid) command line parameter is present
            if (args.Length > 0) {
                int.TryParse(args[0], out max);
                if (max < 1 || max > Int16.MaxValue) max = 60;
                if (args[0] == "0") max = 0;
            }
            for (int i = 0; i <= max; i++) // fill list with values
            {
                BerNum BNumb = CalcBernoulli(i);
                if (BNumb.Numer != BigInteger.Zero) BNumbList.Add(BNumb);
            }
            if (max > 50) Console.WriteLine();
            string strFmt = "B({0, " + w1.ToString() + "}) = {1, " + w2.ToString() + "} / {2}";
            // display formatted list
            foreach (BerNum bn in BNumbList)
                Console.WriteLine(strFmt , bn.index, bn.Numer, bn.Denomin);
            if (System.Diagnostics.Debugger.IsAttached) Console.Read();
        }
    }
}
