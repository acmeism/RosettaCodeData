using System;

namespace Tests_With_Framework_4
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] integers = { -1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1 }; int length = integers.Length;
            int maxsum, beginmax, endmax, sum; maxsum = beginmax = sum = 0; endmax = -1;

            for (int i = 0; i < length; i++)
            {
                sum = 0;
                for (int k = i; k < length; k++)
                {
                    sum += integers[k];
                    if (sum > maxsum)
                    {
                        maxsum = sum;
                        beginmax = i;
                        endmax = k;
                    }
                }
            }

            for (int i = beginmax; i <= endmax; i++)
                Console.WriteLine(integers[i]);

            Console.ReadKey();
        }
    }
}
