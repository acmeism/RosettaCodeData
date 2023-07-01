using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Zeckendorf
{
    class Program
    {
        private static uint Fibonacci(uint n)
        {
            if (n < 2)
            {
                return n;
            }
            else
            {
                return Fibonacci(n - 1) + Fibonacci(n - 2);
            }
        }

        private static string Zeckendorf(uint num)
        {
            IList<uint> fibonacciNumbers = new List<uint>();
            uint fibPosition = 2;

            uint currentFibonaciNum = Fibonacci(fibPosition);

            do
            {
                fibonacciNumbers.Add(currentFibonaciNum);
                currentFibonaciNum = Fibonacci(++fibPosition);
            } while (currentFibonaciNum <= num);

            uint temp = num;
            StringBuilder output = new StringBuilder();

            foreach (uint item in fibonacciNumbers.Reverse())
            {
                if (item <= temp)
                {
                    output.Append("1");
                    temp -= item;
                }
                else
                {
                    output.Append("0");
                }
            }

            return output.ToString();
        }

        static void Main(string[] args)
        {
            for (uint i = 1; i <= 20; i++)
            {
                string zeckendorfRepresentation = Zeckendorf(i);
                Console.WriteLine(string.Format("{0} : {1}", i, zeckendorfRepresentation));
            }

            Console.ReadKey();
        }
    }
}
