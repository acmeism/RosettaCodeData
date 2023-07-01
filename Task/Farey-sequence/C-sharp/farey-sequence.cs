using System;
using System.Collections.Generic;
using System.Linq;

public static class FareySequence
{
    public static void Main() {
        for (int i = 1; i <= 11; i++) {
            Console.WriteLine($"F{i}: " + string.Join(", ", Generate(i).Select(f => $"{f.num}/{f.den}")));
        }
        for (int i = 100; i <= 1000; i+=100) {
            Console.WriteLine($"F{i} has {Generate(i).Count()} terms.");
        }
    }

    public static IEnumerable<(int num, int den)> Generate(int i) {
        var comparer = Comparer<(int n, int d)>.Create((a, b) => (a.n * b.d).CompareTo(a.d * b.n));
        var seq = new SortedSet<(int n, int d)>(comparer);
        for (int d = 1; d <= i; d++) {
            for (int n = 0; n <= d; n++) {
                seq.Add((n, d));
            }
        }
        return seq;
    }
}
