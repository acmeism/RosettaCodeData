using System;
using System.IO;
using System.Linq;

public class Rosetta
{
    public static void Main() => RemoveLines("foobar.txt", start: 1, count: 2);

    static void RemoveLines(string filename, int start, int count = 1) =>
        File.WriteAllLines(filename, File.ReadAllLines(filename)
            .Where((line, index) => index < start - 1 || index >= start + count - 1));
}
