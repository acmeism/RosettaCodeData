using System;
using System.Linq;

internal class Program
{
    private static void Main()
    {
        Console.WriteLine(String.Concat(Enumerable.Range('a', 26).Select(c => (char)c)));
    }
}
