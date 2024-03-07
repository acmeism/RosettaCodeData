using System;
using System.Collections.Generic;
using System.Linq;

public class AliquotSequenceClassifications
{
    private static long ProperDivsSum(long n)
    {
        return Enumerable.Range(1, (int)(n / 2)).Where(i => n % i == 0).Sum(i => (long)i);
    }

    public static bool Aliquot(long n, int maxLen, long maxTerm)
    {
        List<long> s = new List<long>(maxLen) {n};
        long newN = n;

        while (s.Count <= maxLen && newN < maxTerm)
        {
            newN = ProperDivsSum(s.Last());

            if (s.Contains(newN))
            {
                if (s[0] == newN)
                {
                    switch (s.Count)
                    {
                        case 1:
                            return Report("Perfect", s);
                        case 2:
                            return Report("Amicable", s);
                        default:
                            return Report("Sociable of length " + s.Count, s);
                    }
                }
                else if (s.Last() == newN)
                {
                    return Report("Aspiring", s);
                }
                else
                {
                    return Report("Cyclic back to " + newN, s);
                }
            }
            else
            {
                s.Add(newN);
                if (newN == 0)
                    return Report("Terminating", s);
            }
        }

        return Report("Non-terminating", s);
    }

    static bool Report(string msg, List<long> result)
    {
        Console.WriteLine(msg + ": " + string.Join(", ", result));
        return false;
    }

    public static void Main(string[] args)
    {
        long[] arr = {
            11, 12, 28, 496, 220, 1184, 12496, 1264460,
            790, 909, 562, 1064, 1488
        };

        Enumerable.Range(1, 10).ToList().ForEach(n => Aliquot(n, 16, 1L << 47));
        Console.WriteLine();
        foreach (var n in arr)
        {
            Aliquot(n, 16, 1L << 47);
        }
    }
}
