using System;
using System.Collections.Generic;
using System.Linq; // This is required for LINQ extension methods

class Program
{
    static IEnumerable<IEnumerable<int>> GetPermutations(IEnumerable<int> list, int length)
    {
        if (length == 1) return list.Select(t => new int[] { t });

        return GetPermutations(list, length - 1)
            .SelectMany(t => list.Where(e => !t.Contains(e)),
                        (t1, t2) => t1.Concat(new int[] { t2 }));
    }

    static double Determinant(double[][] m)
    {
        double d = 0;
        var p = new List<int>();
        for (int i = 0; i < m.Length; i++)
        {
            p.Add(i);
        }

        var permutations = GetPermutations(p, p.Count);
        foreach (var perm in permutations)
        {
            double pr = 1;
            int sign = Math.Sign(GetPermutationSign(perm.ToList()));
            for (int i = 0; i < perm.Count(); i++)
            {
                pr *= m[i][perm.ElementAt(i)];
            }
            d += sign * pr;
        }

        return d;
    }

    static int GetPermutationSign(IList<int> perm)
    {
        int inversions = 0;
        for (int i = 0; i < perm.Count; i++)
            for (int j = i + 1; j < perm.Count; j++)
                if (perm[i] > perm[j])
                    inversions++;
        return inversions % 2 == 0 ? 1 : -1;
    }

    static double Permanent(double[][] m)
    {
        double d = 0;
        var p = new List<int>();
        for (int i = 0; i < m.Length; i++)
        {
            p.Add(i);
        }

        var permutations = GetPermutations(p, p.Count);
        foreach (var perm in permutations)
        {
            double pr = 1;
            for (int i = 0; i < perm.Count(); i++)
            {
                pr *= m[i][perm.ElementAt(i)];
            }
            d += pr;
        }

        return d;
    }

    static void Main(string[] args)
    {
        double[][] m2 = new double[][] {
            new double[] { 1, 2 },
            new double[] { 3, 4 }
        };

        double[][] m3 = new double[][] {
            new double[] { 2, 9, 4 },
            new double[] { 7, 5, 3 },
            new double[] { 6, 1, 8 }
        };

        Console.WriteLine($"{Determinant(m2)}, {Permanent(m2)}");
        Console.WriteLine($"{Determinant(m3)}, {Permanent(m3)}");
    }
}
