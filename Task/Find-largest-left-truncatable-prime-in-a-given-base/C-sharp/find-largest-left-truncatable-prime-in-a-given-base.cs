using Mpir.NET;  // 0.4.0
using System;   // 4790@3.6
using System.Collections.Generic;
class MaxLftTrP_B
{
    static void Main()
    {
        mpz_t p; var sw = System.Diagnostics.Stopwatch.StartNew(); L(3);
        for (uint b = 3; b < 13; b++)
        {
            sw.Restart(); p = L(b);
            Console.WriteLine("{0} {1,2} {2}", sw.Elapsed, b, p);
        }
        Console.Read();
    }

    static mpz_t L(uint b)
    {
        var p = new List<mpz_t>(); mpz_t np = 0;
        while ((np = nxtP(np)) < b) p.Add(np);
        int i0 = 0, i = 0, i1 = p.Count - 1; mpz_t n0 = b, n, n1 = b * (b - 1);
        for (; i < p.Count; n0 *= b, n1 *= b, i0 = i1 + 1, i1 = p.Count - 1)
            for (n = n0; n <= n1; n += n0)
                for (i = i0; i <= i1; i++)
                    if (mpir.mpz_probab_prime_p(np = n + p[i], 15) > 0) p.Add(np);
        return p[p.Count - 1];
    }

    static mpz_t nxtP(mpz_t n) { mpz_t p = 0; mpir.mpz_nextprime(p, n); return p; }
}
