using System;
using System.Linq;

class Program
{
    static void Main()
    {
        Enumerable.Range(1, 99).Reverse().Select(x =>
            $"{x} bottle{(x == 1 ? "" : "s")} of beer on the wall, {x} bottle{(x == 1 ? "" : "s")} of beer!\n" +
            $"Take {(x == 1 ? "it" : "one")} down, pass it around, {(x == 1 ? "no more" : (x - 1).ToString())} bottles of beer on the wall!\n"
        ).ToList().ForEach(x => Console.WriteLine(x));
    }
}
