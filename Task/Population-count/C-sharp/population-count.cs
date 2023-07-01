using System;
using System.Linq;

namespace PopulationCount
{
    class Program
    {
        private static int PopulationCount(long n)
        {
            string binaryn = Convert.ToString(n, 2);
            return binaryn.ToCharArray().Where(t => t == '1').Count();
        }

        static void Main(string[] args)
        {
            Console.WriteLine("Population Counts:");
            Console.Write("3^n :   ");

            int count = 0;

            while (count < 30)
            {
                double n = Math.Pow(3f, (double)count);
                int popCount = PopulationCount((long)n);
                Console.Write(string.Format("{0} ", popCount));
                count++;
            }

            Console.WriteLine();
            Console.Write("Evil:   ");

            count = 0;
            int i = 0;

            while (count < 30)
            {
                int popCount = PopulationCount(i);

                if (popCount % 2 == 0)
                {
                    count++;
                    Console.Write(string.Format("{0} ", i));
                }

                i++;
            }

            Console.WriteLine();
            Console.Write("Odious: ");

            count = 0;
            i = 0;

            while (count < 30)
            {
                int popCount = PopulationCount(i);

                if (popCount % 2 != 0)
                {
                    count++;
                    Console.Write(string.Format("{0} ", i));
                }

                i++;
            }

            Console.ReadKey();
        }
    }
}
