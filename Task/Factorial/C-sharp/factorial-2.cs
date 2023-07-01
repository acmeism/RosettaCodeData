using System;

class Program
{
    static int Factorial(int number)
    {
        if(number < 0)
            throw new ArgumentOutOfRangeException(nameof(number), number, "Must be zero or a positive number.");

        return number == 0 ? 1 : number * Factorial(number - 1);
    }

    static void Main()
    {
        Console.WriteLine(Factorial(10));
    }
}
