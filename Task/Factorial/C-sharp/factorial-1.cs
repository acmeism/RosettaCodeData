using System;

class Program
{
    static int Factorial(int number)
    {
        if(number < 0)
            throw new ArgumentOutOfRangeException(nameof(number), number, "Must be zero or a positive number.");

        var accumulator = 1;
        for (var factor = 1; factor <= number; factor++)
        {
            accumulator *= factor;
        }
        return accumulator;
    }

    static void Main()
    {
        Console.WriteLine(Factorial(10));
    }
}
