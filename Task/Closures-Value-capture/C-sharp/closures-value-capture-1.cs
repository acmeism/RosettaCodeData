using System;
using System.Linq;

class Program
{
    static void Main()
    {
        var captor = (Func<int, Func<int>>)(number => () => number * number);
        var functions = Enumerable.Range(0, 10).Select(captor);
        foreach (var function in functions.Take(9))
        {
            Console.WriteLine(function());
        }
    }
}
