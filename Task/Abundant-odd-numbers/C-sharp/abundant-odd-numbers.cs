using static System.Console;
using System.Collections.Generic;
using System.Linq;

public static class AbundantOddNumbers
{
    public static void Main() {
        WriteLine("First 25 abundant odd numbers:");
        foreach (var x in AbundantNumbers().Take(25)) WriteLine(x.Format());
        WriteLine();
        WriteLine($"The 1000th abundant odd number: {AbundantNumbers().ElementAt(999).Format()}");
        WriteLine();
        WriteLine($"First abundant odd number > 1b: {AbundantNumbers(1_000_000_001).First().Format()}");
    }

    static IEnumerable<(int n, int sum)> AbundantNumbers(int start = 3) =>
        start.UpBy(2).Select(n => (n, sum: n.DivisorSum())).Where(x => x.sum > x.n);

    static int DivisorSum(this int n) => 3.UpBy(2).TakeWhile(i => i * i <= n).Where(i => n % i == 0)
        .Select(i => (a:i, b:n/i)).Sum(p => p.a == p.b ? p.a : p.a + p.b) + 1;

    static IEnumerable<int> UpBy(this int n, int step) {
        for (int i = n; ; i+=step) yield return i;
    }

    static string Format(this (int n, int sum) pair) => $"{pair.n:N0} with sum {pair.sum:N0}";
}
