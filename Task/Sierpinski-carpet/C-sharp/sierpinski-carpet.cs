using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static List<string> NextCarpet(List<string> carpet)
    {
        return carpet.Select(x => x + x + x)
                     .Concat(carpet.Select(x => x + x.Replace('#', ' ') + x))
                     .Concat(carpet.Select(x => x + x + x)).ToList();
    }

    static List<string> SierpinskiCarpet(int n)
    {
        return Enumerable.Range(1, n).Aggregate(new List<string> { "#" }, (carpet, _) => NextCarpet(carpet));
    }

    static void Main(string[] args)
    {
        foreach (string s in SierpinskiCarpet(3))
            Console.WriteLine(s);
    }
}
