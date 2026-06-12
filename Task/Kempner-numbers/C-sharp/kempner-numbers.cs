using System;
using System.Collections.Generic;
using System.Linq;

 class Program
{
    static Dictionary<ulong,ulong> FactorInt(ulong n)
    {
        var res = new Dictionary<ulong,ulong>();
        ulong e;

        for (ulong p = 2; p * p <= n; p++) {
            for (e = 0; n % p == 0; n /= p) e++;
            if (e > 0) res[p] = e;
        }
        if (n > 1) res[n] = 1;
        return res;
    }

    static ulong FactorialPrimeExponent(ulong k, ulong p)
    {
        ulong res = 0;
        while (k > 0) {
            k = k / p;
            res += k;
        }
        return res;
    }

    static bool FactorialDivisibleByNumber(ulong kFac, ulong n)
    {
        foreach (var pair in FactorInt(n)) {
            ulong p = pair.Key;
            ulong e = pair.Value;

            if (FactorialPrimeExponent(kFac, p) < e)
                return false;
        }
        return true;
    }

    static ulong Kempner(ulong n)
    {
        if (n == 1) return 1;
        ulong k = FactorInt(n).Keys.Max();
        while (!FactorialDivisibleByNumber(k, n)) k++;
        return k;
    }

    static void Main()
    {
        Console.WriteLine("First fifty Kempner numbers:");
        for (ulong n = 1; n <= 50; n++) {
            Console.Write($"{Kempner(n),4}");
            if (n % 10 == 0) Console.WriteLine();
        }

        Console.WriteLine();
        for (ulong n = 77135679311; n <= 77135679321; n++)
            Console.WriteLine($"S({n}) = {Kempner(n)}");
    }
}
