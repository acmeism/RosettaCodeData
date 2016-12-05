using System;
using System.IO;

public class Rosetta
{
    /* C# 6 version:
    public static void Main() => RemoveLines("foobar.txt", start: 1, count: 2);
    */

    public static void Main() {
        RemoveLines("foobar.txt", start: 1, count: 2);
    }

    static void RemoveLines(string filename, int start, int count = 1) {
        //Reads and writes one line at a time, so no memory overhead.
        File.WriteAllLines(filename, File.ReadAllLines(filename)
            .Where((line, index) => index < start - 1 || index >= start + count - 1));
    }
}
