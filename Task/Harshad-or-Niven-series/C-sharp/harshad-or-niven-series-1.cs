using System;
using System.Collections.Generic;

namespace Harshad
{
    class Program
    {
        public static bool IsHarshad(int n)
        {
            char[] inputChars = n.ToString().ToCharArray();
            IList<byte> digits = new List<byte>();

            foreach (char digit in inputChars)
            {
                digits.Add((byte)Char.GetNumericValue(digit));
            }

            if (n < 1)
            {
                return false;
            }

            int sum = 0;

            foreach (byte digit in digits)
            {
                sum += digit;
            }

            return n % sum == 0;
        }

        static void Main(string[] args)
        {
            int i = 1;
            int count = 0;

            while (true)
            {
                if (IsHarshad(i))
                {
                    count++;

                    if (count <= 20)
                    {
                        Console.Write(string.Format("{0} ", i));
                    }
                    else if (i > 1000)
                    {
                        Console.Write(string.Format("{0} ", i));
                        break;
                    }
                }

                i++;
            }

            Console.ReadKey();
        }
    }
}
