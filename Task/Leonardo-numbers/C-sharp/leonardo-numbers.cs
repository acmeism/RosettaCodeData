using System;
using System.Linq;

public class Program
{
    public static void Main() {
        Console.WriteLine(string.Join(" ", Leonardo().Take(25)));
        Console.WriteLine(string.Join(" ", Leonardo(L0: 0, L1: 1, add: 0).Take(25)));
    }

    public static IEnumerable<int> Leonardo(int L0 = 1, int L1 = 1, int add = 1) {
        while (true) {
            yield return L0;
            (L0, L1) = (L1, L0 + L1 + add);
        }
    }
}
