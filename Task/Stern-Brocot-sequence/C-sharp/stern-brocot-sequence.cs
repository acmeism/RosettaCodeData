using System;
using System.Collections.Generic;
using System.Linq;

static class Program {
    static List<int> l = new List<int>() { 1, 1 };

    static int gcd(int a, int b) {
        return a > 0 ? a < b ? gcd(b % a, a) : gcd(a % b, b) : b; }

    static void Main(string[] args) {
        int max = 1000; int take = 15; int i = 1;
        int[] selection = new[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100 };
        do { l.AddRange(new List<int>() { l[i] + l[i - 1], l[i] }); i += 1; }
        while (l.Count < max || l[l.Count - 2] != selection.Last());
        Console.Write("The first {0} items In the Stern-Brocot sequence: ", take);
        Console.WriteLine("{0}\n", string.Join(", ", l.Take(take)));
        Console.WriteLine("The locations of where the selected numbers (1-to-10, & 100) first appear:");
        foreach (int ii in selection) {
            int j = l.FindIndex(x => x == ii) + 1; Console.WriteLine("{0,3}: {1:n0}", ii, j); }
        Console.WriteLine(); bool good = true;
        for (i = 1; i <= max; i++) { if (gcd(l[i], l[i - 1]) != 1) { good = false; break; } }
        Console.WriteLine("The greatest common divisor of all the two consecutive items of the" +
                          " series up to the {0}th item is {1}always one.", max, good ? "" : "not ");
    }
}
