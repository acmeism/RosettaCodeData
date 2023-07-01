using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    public static void Main()
    {
        const int maxSum = 100;
        var pairs = (
            from X in 2.To(maxSum / 2 - 1)
            from Y in (X + 1).To(maxSum - 2).TakeWhile(y => X + y <= maxSum)
            select new { X, Y, S = X + Y, P = X * Y }
            ).ToHashSet();

        Console.WriteLine(pairs.Count);

        var uniqueP = pairs.GroupBy(pair => pair.P).Where(g => g.Count() == 1).Select(g => g.Key).ToHashSet();

        pairs.ExceptWith(pairs.GroupBy(pair => pair.S).Where(g => g.Any(pair => uniqueP.Contains(pair.P))).SelectMany(g => g));
        Console.WriteLine(pairs.Count);

        pairs.ExceptWith(pairs.GroupBy(pair => pair.P).Where(g => g.Count() > 1).SelectMany(g => g));
        Console.WriteLine(pairs.Count);

        pairs.ExceptWith(pairs.GroupBy(pair => pair.S).Where(g => g.Count() > 1).SelectMany(g => g));
        Console.WriteLine(pairs.Count);

        foreach (var pair in pairs) Console.WriteLine(pair);
    }
}

public static class Extensions
{
    public static IEnumerable<int> To(this int start, int end) {
        for (int i = start; i <= end; i++) yield return i;
    }

    public static HashSet<T> ToHashSet<T>(this IEnumerable<T> source) => new HashSet<T>(source);
}
