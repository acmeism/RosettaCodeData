using System;
using System.Collections.Generic;
using System.Linq;

namespace rms
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(rootMeanSquare(Enumerable.Range(1, 10)));
        }

        private static double rootMeanSquare(IEnumerable<int> x)
        {
            return Math.Sqrt(x.Average(i => (double)i * i));
        }
    }
}
