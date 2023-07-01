using System;
using System.Collections.Generic;
using System.Linq;

public static class LoopsWithMultipleRanges
{
    public static void Main() {
        int prod = 1;
        int sum = 0;
        int x = 5;
        int y = -5;
        int z = -2;
        int one = 1;
        int three = 3;
        int seven = 7;

        foreach (int j in Concat(
            For(-three, 3.Pow(3), three),
            For(-seven, seven, x),
            For(555, 550 - y),
            For(22, -28, -three),
            For(1927, 1939),
            For(x, y, z),
            For(11.Pow(x), 11.Pow(x) + one)
        )) {
            sum += Math.Abs(j);
            if (Math.Abs(prod) < (1 << 27) && j != 0) prod *= j;
        }
        Console.WriteLine($" sum = {sum:N0}");
        Console.WriteLine($"prod = {prod:N0}");
    }

    static IEnumerable<int> For(int start, int end, int by = 1) {
        for (int i = start; by > 0 ? (i <= end) : (i >= end); i += by) yield return i;
    }

    static IEnumerable<int> Concat(params IEnumerable<int>[] ranges) => ranges.Aggregate((acc, r) => acc.Concat(r));
    static int Pow(this int b, int e) => (int)Math.Pow(b, e);
}
