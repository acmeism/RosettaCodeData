using System;
using System.Linq;

public class Program
{
    static void Main
    {
        string[] input = {"", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"};
        foreach (string s in input) {
            Console.WriteLine($"\"{s}\" (Length {s.Length}) " +
                string.Join(", ",
                    s.Select((c, i) => (c, i))
                    .GroupBy(t => t.c).Where(g => g.Count() > 1)
                    .Select(g => $"'{g.Key}' (0X{(int)g.Key:X})[{string.Join(", ", g.Select(t => t.i))}]")
                    .DefaultIfEmpty("All characters are unique.")
                )
            );
        }
    }
}
