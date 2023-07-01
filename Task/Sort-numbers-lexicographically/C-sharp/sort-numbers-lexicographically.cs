using static System.Console;
using static System.Linq.Enumerable;

public class Program
{
    public static void Main() {
        foreach (int n in new [] { 0, 5, 13, 21, -22 }) WriteLine($"{n}: {string.Join(", ", LexOrder(n))}");
    }

    public static IEnumerable<int> LexOrder(int n) => (n < 1 ? Range(n, 2 - n) : Range(1, n)).OrderBy(i => i.ToString());
}
