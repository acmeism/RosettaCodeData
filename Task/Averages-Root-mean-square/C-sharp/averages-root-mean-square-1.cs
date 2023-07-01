using System;

namespace rms
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] x = new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            Console.WriteLine(rootMeanSquare(x));
        }

        private static double rootMeanSquare(int[] x)
        {
            double sum = 0;
            for (int i = 0; i < x.Length; i++)
            {
                sum += (x[i]*x[i]);
            }
            return Math.Sqrt(sum / x.Length);
        }
    }
}
