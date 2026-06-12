using System;
using System.Collections.Generic;

class Program
{
    // starts as an ordinary odds-only prime sieve, but becomes
    // extraordinary after the else statement...
    static List<uint> sieve(uint max, bool ordinary = false)
    {
        uint k = ((max - 3) >> 1) + 1,
           lmt = ((uint)(Math.Sqrt(max++) - 3) >> 1) + 1;
        var pl = new List<uint> { };
        var ic = new bool[k];
        for (uint i = 0, p = 3; i < lmt; i++, p += 2) if (!ic[i])
                for (uint j = (p * p - 3) >> 1; j < k; j += p) ic[j] = true;
        if (ordinary)
        {
            pl.Add(2);
            for (uint i = 0, j = 3; i < k; i++, j += 2)
                if (!ic[i]) pl.Add(j);
        }
        else
            for (uint i = 0, j = 3, t = j; i < k; i++, t = j += 2)
                if (!ic[i])
                {
                    while ((t /= 10) > 0)
                        if (((t % 10) & 1) == 1) goto skip;
                    pl.Add(j);
                skip:;
                }
        return pl;
    }

    static void Main(string[] args)
    {
        var pl = sieve((uint)1e9);
        uint c = 0, l = 10, p = 1;
        Console.WriteLine("List of one-odd-digit primes < 1,000:");
        for (int i = 0; pl[i] < 1000; i++)
            Console.Write("{0,3}{1}", pl[i], i % 9 == 8 ? "\n" : "  ");
        string fmt = "\nFound {0:n0} one-odd-digit primes < 10^{1} ({2:n0})";
        foreach (var itm in pl)
            if (itm < l) c++;
            else Console.Write(fmt, c++, p++, l, l *= 10);
        Console.Write(fmt, c++, p++, l);
    }
}
