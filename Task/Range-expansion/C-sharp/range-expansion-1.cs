using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

class Program
{
    static void Main(string[] args)
    {
        var rangeString = "-6,-3--1,3-5,7-11,14,15,17-20";
        var matches = Regex.Matches(rangeString, @"(?<f>-?\d+)-(?<s>-?\d+)|(-?\d+)");
        var values = new List<string>();

        foreach (var m in matches.OfType<Match>())
        {
            if (m.Groups[1].Success)
            {
                values.Add(m.Value);
                continue;
            }

            var start = Convert.ToInt32(m.Groups["f"].Value);
            var end = Convert.ToInt32(m.Groups["s"].Value) + 1;

            values.AddRange(Enumerable.Range(start, end - start).Select(v => v.ToString()));
        }

        Console.WriteLine(string.Join(", ", values));
    }
}
