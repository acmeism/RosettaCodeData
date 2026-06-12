using System;
using System.Collections.Generic;
using System.Linq;

public static class JaccardIndex
{
    public static void Main(string[] args)
    {
        var tests = new List<List<int>>
        {
            new List<int> { },
            new List<int> { 1, 2, 3, 4, 5 },
            new List<int> { 1, 3, 5, 7, 9 },
            new List<int> { 2, 4, 6, 8, 10 },
            new List<int> { 2, 3, 5, 7 },
            new List<int> { 8 }
        };

        Console.WriteLine("     Set A              Set B         J(A, B)");
        Console.WriteLine("---------------------------------------------");

        foreach (var a in tests)
        {
            foreach (var b in tests)
            {
                Console.WriteLine($"{FormatList(a),-19}{FormatList(b),-19}{CalculateJaccardIndex(a, b):F5}");
            }
        }
    }

    private static double CalculateJaccardIndex(List<int> A, List<int> B)
    {
        var intersection = new HashSet<int>(A);
        intersection.IntersectWith(B);

        var union = new HashSet<int>(A);
        union.UnionWith(B);

        int i = intersection.Count;
        int u = union.Count;

        return u == 0 ? 1.0 : i == 0 ? 0.0 : (double)i / u;
    }

    private static string FormatList(List<int> list)
    {
        if (list.Count == 0)
            return "[]";

        return "[" + string.Join(", ", list) + "]";
    }
}
