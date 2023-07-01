using System.Collections.Generic;
using static System.Linq.Enumerable;
using static System.Console;

public static class Program
{
    public static void Main()
    {
        WriteLine(string.Join(" ", From(1).Where(IsHarshad).Take(20)));
        WriteLine(From(1001).First(IsHarshad));
    }

    static bool IsHarshad(this int i) => i % i.Digits().Sum() == 0;

    static IEnumerable<int> From(int start) {
        for (int i = start; ; i++) yield return i;
    }

    static IEnumerable<int> Digits(this int n) {
        for (; n > 0; n /= 10) yield return n % 10;
    }
}
