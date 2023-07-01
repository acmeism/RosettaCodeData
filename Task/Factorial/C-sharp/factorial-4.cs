using System;
using System.Linq;

class Program
{
    static int Factorial(int number)
    {
        return Enumerable.Range(1, number).Aggregate((accumulator, factor) => accumulator * factor);
    }

    static void Main()
    {
        Console.WriteLine(Factorial(10));
    }
}
