using System;
using System.Linq;

namespace HofstadterConway
{
    class Program
    {
        static int[] GenHofstadterConway(int max)
        {
            int[] result = new int[max];
            result[0]=result[1]=1;
            for (int ix = 2; ix < max; ix++)
                result[ix] = result[result[ix - 1] - 1] + result[ix - result[ix - 1]];
            return result;
        }

        static void Main(string[] args)
        {
            double[] adiv = new double[1 << 20];
            {
                int[] a = GenHofstadterConway(1 << 20);
                for (int i = 0; i < 1 << 20; i++)
                    adiv[i] = a[i] / (double)(i + 1);
            }
            for (int p = 2; p <= 20; p++)
            {
                var max = Enumerable.Range(
                     (1 << (p - 1)) - 1,
                     (1 << p) - (1 << (p - 1))
                     )
                     .Select(ix => new { I = ix + 1, A = adiv[ix] })
                     .OrderByDescending(x => x.A)
                     .First();
                Console.WriteLine("Maximum from 2^{0} to 2^{1} is {2} at {3}",
                    p - 1, p, max.A, max.I);
            }
            Console.WriteLine("The winning number is {0}.",
                Enumerable.Range(0, 1 << 20)
                    .Last(i => (adiv[i] > 0.55)) + 1
                );
        }
    }
}
