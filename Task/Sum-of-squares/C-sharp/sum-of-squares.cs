using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static int SumOfSquares(IEnumerable<int> list)
    {
        return list.Sum(x => x * x);
    }
    static void Main(string[] args)
    {
        Console.WriteLine(SumOfSquares(new int[] { 4, 8, 15, 16, 23, 42 })); // 2854
        Console.WriteLine(SumOfSquares(new int[] { 1, 2, 3, 4, 5 })); // 55
        Console.WriteLine(SumOfSquares(new int[] { })); // 0
    }
}
