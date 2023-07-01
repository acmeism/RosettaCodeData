using System;

namespace NonDecimalRadicesOutput
{
    class Program
    {
        static void Main(string[] args)
        {
            for (int i = 0; i < 42; i++)
            {
                string binary = Convert.ToString(i, 2);
                string octal = Convert.ToString(i, 8);
                string hexadecimal = Convert.ToString(i, 16);
                Console.WriteLine(string.Format("Decimal: {0}, Binary: {1}, Octal: {2}, Hexadecimal: {3}", i, binary, octal, hexadecimal));
            }

            Console.ReadKey();
        }
    }
}
