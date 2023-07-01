using System;

namespace GapfulNumbers
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("The first 30 gapful numbers are: ");
            /* Starting at 100, find 30 gapful numbers */
            FindGap(100, 30);

            Console.WriteLine("The first 15 gapful numbers > 1,000,000 are: ");
            FindGap(1000000, 15);

            Console.WriteLine("The first 10 gapful numbers > 1,000,000,000 are: ");
            FindGap(1000000000, 10);

            Console.Read();
        }

        public static int firstNum(int n)
        {
            /*Divide by ten until the leading digit remains.*/
            while (n >= 10)
            {
                n /= 10;
            }
            return (n);
        }

        public static int lastNum(int n)
        {
            /*Modulo gives you the last digit. */
            return (n % 10);
        }

        static void FindGap(int n, int gaps)
        {
            int count = 0;
            while (count < gaps)
            {

                /* We have to convert our first and last digits to strings to concatenate.*/
                string concat = firstNum(n).ToString() + lastNum(n).ToString();
                /* And then convert our concatenated string back to an integer. */
                int i = Convert.ToInt32(concat);

                /* Modulo with our new integer and output the result. */
                if (n % i == 0)
                {
                    Console.Write(n + " ");
                    count++;
                    n++;
                }
                else
                {
                    n++;
                    continue;
                }
            }
        }
    }
}
