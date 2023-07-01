using System;
using System.Collections.Generic;

static class Program
{
    static void Main()
    {
        Example(-2, 2, 1, "Normal");
        Example(-2, 2, 0, "Zero increment");
        Example(-2, 2, -1, "Increments away from stop value");
        Example(-2, 2, 10, "First increment is beyond stop value");
        Example(2, -2, 1, "Start more than stop: positive increment");
        Example(2, 2, 1, "Start equal stop: positive increment");
        Example(2, 2, -1, "Start equal stop: negative increment");
        Example(2, 2, 0, "Start equal stop: zero increment");
        Example(0, 0, 0, "Start equal stop equal zero: zero increment");
    }

    static IEnumerable<int> Range(int start, int stop, int increment)
    {
        // To replicate the (arguably more correct) behavior of VB.NET:
        //for (int i = start; increment >= 0 ? i <= stop : stop <= i; i += increment)

        // Decompiling the IL emitted by the VB compiler (uses shifting right by 31 as the signum function and bitwise xor in place of the conditional expression):
        //for (int i = start; ((increment >> 31) ^ i) <= ((increment >> 31) ^ stop); i += increment)

        // "Naïve" translation.
        for (int i = start; i <= stop; i += increment)
            yield return i;
    }

    static void Example(int start, int stop, int increment, string comment)
    {
        // Add a space, pad to length 50 with hyphens, and add another space.
        Console.Write((comment + " ").PadRight(50, '-') + " ");

        const int MAX_ITER = 9;

        int iteration = 0;
        foreach (int i in Range(start, stop, increment))
        {
            Console.Write("{0,2} ", i);

            if (++iteration > MAX_ITER) break;
        }

        Console.WriteLine();
    }
}
