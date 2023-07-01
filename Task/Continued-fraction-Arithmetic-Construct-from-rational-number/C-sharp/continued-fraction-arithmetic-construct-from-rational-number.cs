using System;
using System.Collections.Generic;

class Program
{
    static IEnumerable<int> r2cf(int n1, int n2)
    {
        while (Math.Abs(n2) > 0)
        {
            int t1 = n1 / n2;
            int t2 = n2;
            n2 = n1 - t1 * n2;
            n1 = t2;
            yield return t1;
        }
    }

    static void spit(IEnumerable<int> f)
    {
        foreach (int n in f) Console.Write(" {0}", n);
        Console.WriteLine();
    }

    static void Main(string[] args)
    {
        spit(r2cf(1, 2));
        spit(r2cf(3, 1));
        spit(r2cf(23, 8));
        spit(r2cf(13, 11));
        spit(r2cf(22, 7));
        spit(r2cf(-151, 77));
        for (int scale = 10; scale <= 10000000; scale *= 10)
        {
            spit(r2cf((int)(Math.Sqrt(2) * scale), scale));
        }
        spit(r2cf(31, 10));
        spit(r2cf(314, 100));
        spit(r2cf(3142, 1000));
        spit(r2cf(31428, 10000));
        spit(r2cf(314285, 100000));
        spit(r2cf(3142857, 1000000));
        spit(r2cf(31428571, 10000000));
        spit(r2cf(314285714, 100000000));
    }
}
