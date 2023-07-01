using System;  // 4790@3.6
using System.Collections.Generic;
class truncatable_primes
{
    static void Main()
    {
        uint m = 1000000;
        Console.Write("L " + L(m) + " R " + R(m) + "  ");
        var sw = System.Diagnostics.Stopwatch.StartNew();
        for (int i = 1000; i > 0; i--) { L(m); R(m); }
        Console.Write(sw.Elapsed); Console.Read();
    }

    static uint L(uint n)
    {
        n -= n & 1; n--;
        for (uint d, d1 = 100; ; n -= 2)
        {
            while (n % 3 == 0 || n % 5 == 0 || n % 7 == 0) n -= 2;
            if ((d = n % 10) == 3 || d == 7)
            {
                while (d1 < n && d < (d = n % d1) && isP(d)) d1 *= 10;
                if (d1 > n && isP(n)) return n; d1 = 100;
            }
        }
    }

    static uint R(uint m)
    {
        var p = new List<uint>() { 2, 3, 5, 7 }; uint n = 20, np;
        for (int i = 1; i < p.Count; n = 10 * p[i++])
        {
            if ((np = n + 1) >= m) break; if (isP(np)) p.Add(np);
            if ((np = n + 3) >= m) break; if (isP(np)) p.Add(np);
            if ((np = n + 7) >= m) break; if (isP(np)) p.Add(np);
            if ((np = n + 9) >= m) break; if (isP(np)) p.Add(np);
        }
        return p[p.Count - 1];
    }

    static bool isP(uint n)
    {
        if (n < 7) return n == 2 || n == 3 || n == 5;
        if ((n & 1) == 0 || n % 3 == 0 || n % 5 == 0) return false;
        for (uint r = (uint)Math.Sqrt(n), d = 7; d <= r; d += 30)
            if (n % (d + 00) == 0 || n % (d + 04) == 0 ||
                n % (d + 06) == 0 || n % (d + 10) == 0 ||
                n % (d + 12) == 0 || n % (d + 16) == 0 ||
                n % (d + 22) == 0 || n % (d + 24) == 0) return false;
        return true;
    }
}
