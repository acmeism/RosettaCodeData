using System;

namespace exponents
{
    class Program
    {
        static void Main(string[] args)
        {
            /*
             * Like C, C# does not have an exponent operator.
             * Exponentiation is done via Math.Pow, which
             * only takes two arguments
             */
            Console.WriteLine(Math.Pow(Math.Pow(5, 3), 2));
            Console.WriteLine(Math.Pow(5, Math.Pow(3, 2)));
            Console.Read();
        }

    }
}
