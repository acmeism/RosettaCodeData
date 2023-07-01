using System;
using System.Globalization;

namespace PrimeNumberLoopcs
{
    class Program
    {
        static bool isPrime(double number)
        {
            for(double i = number - 1; i > 1; i--)
            {
                if (number % i == 0)
                    return false;
            }
            return true;
        }
        static void Main(string[] args)
        {
            NumberFormatInfo nfi = new CultureInfo("en-US", false).NumberFormat;
            nfi.NumberDecimalDigits = 0;
            double i = 42;
            int n = 0;
            while (n < 42)
            {
                if (isPrime(i))
                {
                    n++;
                    Console.WriteLine("n = {0,-20} {1,20}", n, i.ToString("N", nfi));
                    i += i - 1;
                }
                i++;
            }
        }
    }
}
