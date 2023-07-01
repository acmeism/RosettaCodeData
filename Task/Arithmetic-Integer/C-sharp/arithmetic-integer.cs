using System;

class Program
{
    static void Main(string[] args)
    {
        int a = Convert.ToInt32(args[0]);
        int b = Convert.ToInt32(args[1]);

        Console.WriteLine("{0} + {1} = {2}", a, b, a + b);
        Console.WriteLine("{0} - {1} = {2}", a, b, a - b);
        Console.WriteLine("{0} * {1} = {2}", a, b, a * b);
        Console.WriteLine("{0} / {1} = {2}", a, b, a / b); // truncates towards 0
        Console.WriteLine("{0} % {1} = {2}", a, b, a % b); // matches sign of first operand
        Console.WriteLine("{0} to the power of {1} = {2}", a, b, Math.Pow(a, b));
    }
}
