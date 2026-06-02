using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class Program
{
    static bool IsIsogram(string s)
    {
        return s.GroupBy(c => c).Select(g => g.Count()).Distinct().Count() == 1;
    }

    static int IsogramLevel(string s)
    {
        return s.Count(c => c == s[0]);
    }

    static void Main()
    {
        var words = File.ReadAllLines("unixdict.txt");
        var isograms = words.Where(IsIsogram).ToList();

        Console.WriteLine("n-isograms with n > 1:");
        var result = isograms
            .Where(s => IsogramLevel(s) > 1)
            .OrderBy(s => (-IsogramLevel(s), -s.Length, s));

        foreach (var s in result)
            Console.WriteLine(s);

        Console.WriteLine();
        Console.WriteLine("Heterograms with more than 10 letters:");
        result = isograms
            .Where(s => IsogramLevel(s) == 1 && s.Length > 10)
            .OrderBy(s => (-s.Length, s));

        foreach (var s in result)
            Console.WriteLine(s);
    }
}
