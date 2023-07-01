using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    public static List<String> Sierpinski(int n)
    {
        var lines = new List<string> { "*" };
        string space = " ";

        for (int i = 0; i < n; i++)
        {
            lines = lines.Select(x => space + x + space)
                         .Concat(lines.Select(x => x + " " + x)).ToList();
            space += space;
        }

        return lines;
    }

    static void Main(string[] args)
    {
        foreach (string s in Sierpinski(4))
            Console.WriteLine(s);
    }
}
