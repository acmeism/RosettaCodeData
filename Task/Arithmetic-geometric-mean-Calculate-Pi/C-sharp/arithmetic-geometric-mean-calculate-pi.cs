using System;
using System.Numerics;

class AgmPie
{
    static BigInteger IntSqRoot(BigInteger valu, BigInteger guess)
    {
        BigInteger term; do {
            term = valu / guess; if (BigInteger.Abs(term - guess) <= 1) break;
            guess += term; guess >>= 1;
        } while (true); return guess;
    }

    static BigInteger ISR(BigInteger term, BigInteger guess)
    {
        BigInteger valu = term * guess; do {
            if (BigInteger.Abs(term - guess) <= 1) break;
            guess += term; guess >>= 1; term = valu / guess;
        } while (true); return guess;
    }

    static BigInteger CalcAGM(BigInteger lam, BigInteger gm, ref BigInteger z,
                              BigInteger ep)
    {
        BigInteger am, zi; ulong n = 1; do {
            am = (lam + gm) >> 1; gm = ISR(lam, gm);
            BigInteger v = am - lam; if ((zi = v * v * n) < ep) break;
            z -= zi; n <<= 1; lam = am;
        } while (true); return am;
    }

    static BigInteger BIP(int exp, ulong man = 1)
    {
        BigInteger rv = BigInteger.Pow(10, exp); return man == 1 ? rv : man * rv;
    }

    static void Main(string[] args)
    {
        int d = 25000;
        if (args.Length > 0)
        {
            int.TryParse(args[0], out d);
            if (d < 1 || d > 999999) d = 25000;
        }
        DateTime st = DateTime.Now;
        BigInteger am = BIP(d),
          gm = IntSqRoot(BIP(d + d - 1, 5),
                             BIP(d - 15, (ulong)(Math.Sqrt(0.5) * 1e+15))),
          z = BIP(d + d - 2, 25),
          agm = CalcAGM(am, gm, ref z, BIP(d + 1)),
          pi = agm * agm * BIP(d - 2) / z;
        Console.WriteLine("Computation time: {0:0.0000} seconds ",
                             (DateTime.Now - st).TotalMilliseconds / 1000);
        string s = pi.ToString();
        Console.WriteLine("{0}.{1}", s[0], s.Substring(1));
        if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
    }
}
