using System;

namespace MagicSquareDoublyEven
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = 8;
            var result = MagicSquareDoublyEven(n);
            for (int i = 0; i < result.GetLength(0); i++)
            {
                for (int j = 0; j < result.GetLength(1); j++)
                    Console.Write("{0,2} ", result[i, j]);
                Console.WriteLine();
            }
            Console.WriteLine("\nMagic constant: {0} ", (n * n + 1) * n / 2);
            Console.ReadLine();
        }

        private static int[,] MagicSquareDoublyEven(int n)
        {
            if (n < 4 || n % 4 != 0)
                throw new ArgumentException("base must be a positive "
                        + "multiple of 4");

            // pattern of count-up vs count-down zones
            int bits = 0b1001_0110_0110_1001;
            int size = n * n;
            int mult = n / 4;  // how many multiples of 4

            int[,] result = new int[n, n];

            for (int r = 0, i = 0; r < n; r++)
            {
                for (int c = 0; c < n; c++, i++)
                {
                    int bitPos = c / mult + (r / mult) * 4;
                    result[r, c] = (bits & (1 << bitPos)) != 0 ? i + 1 : size - i;
                }
            }
            return result;
        }
    }
}
