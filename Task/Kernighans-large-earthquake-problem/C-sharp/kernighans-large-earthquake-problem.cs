using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    static void Main() {
        foreach (var earthquake in LargeEarthquakes("data.txt", 6))
            Console.WriteLine(string.Join(" ", earthquake));
    }

    static IEnumerable<string[]> LargeEarthquakes(string filename, double limit) =>
        from line in File.ReadLines(filename)
        let parts = line.Split(default(char[]), StringSplitOptions.RemoveEmptyEntries)
        where double.Parse(parts[2]) > limit
        select parts;

}
