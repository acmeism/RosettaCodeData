using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class LawOfCosinesTriples
{
    public static void Main2() {
        PrintTriples(60, 13);
        PrintTriples(90, 13);
        PrintTriples(120, 13);
        PrintTriples(60, 10_000, true, false);
    }

    private static void PrintTriples(int degrees, int maxSideLength, bool notAllTheSameLength = false, bool print = true) {
        string s = $"{degrees} degree triangles in range 1..{maxSideLength}";
        if (notAllTheSameLength) s += " where not all sides are the same";
        Console.WriteLine(s);
        int count = 0;
        var triples = FindTriples(degrees, maxSideLength);
        if (notAllTheSameLength) triples = triples.Where(NotAllTheSameLength);
        foreach (var triple in triples) {
            count++;
            if (print) Console.WriteLine(triple);
        }
        Console.WriteLine($"{count} solutions");
    }

    private static IEnumerable<(int a, int b, int c)> FindTriples(int degrees, int maxSideLength) {
        double radians = degrees * Math.PI / 180;
        int coefficient = (int)Math.Round(Math.Cos(radians) * -2, MidpointRounding.AwayFromZero);
        int maxSideLengthSquared = maxSideLength * maxSideLength;
        return
            from a in Range(1, maxSideLength)
            from b in Range(1, a)
            let cc = a * a + b * b + a * b * coefficient
            where cc <= maxSideLengthSquared
            let c = (int)Math.Sqrt(cc)
            where c * c == cc
            select (a, b, c);
    }

    private static bool NotAllTheSameLength((int a, int b, int c) triple) => triple.a != triple.b || triple.a != triple.c;
}
