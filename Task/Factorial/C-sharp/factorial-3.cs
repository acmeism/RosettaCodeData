using System;

class Program
{
    static int Factorial(int number)
    {
        if(number < 0)
            throw new ArgumentOutOfRangeException(nameof(number), number, "Must be zero or a positive number.");

        return Factorial(number, 1);
    }

    static int Factorial(int number, int accumulator)
    {
        if(number < 0)
            throw new ArgumentOutOfRangeException(nameof(number), number, "Must be zero or a positive number.");
        if(accumulator < 1)
            throw new ArgumentOutOfRangeException(nameof(accumulator), accumulator, "Must be a positive number.");

        return number == 0 ? accumulator : Factorial(number - 1, number * accumulator);
    }

    static void Main()
    {
        Console.WriteLine(Factorial(10));
    }
}
