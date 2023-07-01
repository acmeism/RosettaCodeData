using System;
using System.Globalization;

namespace Rosettacode
{
    class Program
    {
        static void Main()
        {
            for (var number = 0; number < 100; number++)
            {
                if ((number % 3) == 0 & (number % 5) == 0)
                {
                    //For numbers which are multiples of both three and five print "FizzBuzz".
                    Console.WriteLine("FizzBuzz");
                    continue;
                }

                if ((number % 3) == 0) Console.WriteLine("Fizz");
                if ((number % 5) == 0) Console.WriteLine("Buzz");
                if ((number % 3) != 0 && (number % 5) != 0) Console.WriteLine(number.ToString(CultureInfo.InvariantCulture));

                if (number % 5 == 0)
                {
                    Console.WriteLine(Environment.NewLine);
                }
            }
        }
    }
}
