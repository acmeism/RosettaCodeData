using System;
using System.Numerics;
using System.Collections.Generic;

public static class RiordanNumbers
{
    public static void Main()
    {
        const int limit = 10_000;
        BigInteger THREE = new BigInteger(3);

        BigInteger[] riordans = new BigInteger[limit];
        riordans[0] = BigInteger.One;
        riordans[1] = BigInteger.Zero;
        for (int n = 2; n < limit; n++)
        {
            BigInteger term = BigInteger.Multiply(2, riordans[n - 1]) + BigInteger.Multiply(THREE, riordans[n - 2]);
            riordans[n] = BigInteger.Divide(BigInteger.Multiply(n - 1, term), new BigInteger(n + 1));
        }

        Console.WriteLine("The first 32 Riordan numbers:");
        for (int i = 0; i < 32; i++)
        {
            Console.Write($"{riordans[i],14}{(i % 4 == 3 ? "\n" : " ")}");
        }
        Console.WriteLine();

        foreach (int count in new List<int> { 1_000, 10_000 })
        {
            int length = riordans[count - 1].ToString().Length;
            Console.WriteLine($"The {count}th Riordan number has {length} digits");
        }
    }
}
