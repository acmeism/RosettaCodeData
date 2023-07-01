using System;
using System.Collections.Generic;

namespace ConsoleApplication1
{
    class Program
    {
        public static void Main()
        {
            int longestChain = 0, longestNumber = 0;

            var recursiveLengths = new Dictionary<int, int>();

            const int maxNumber = 100000;

            for (var i = 1; i <= maxNumber; i++)
            {
                var chainLength = Hailstone(i, recursiveLengths);
                if (longestChain >= chainLength)
                    continue;

                longestChain = chainLength;
                longestNumber = i;
            }
            Console.WriteLine("max below {0}: {1} ({2} steps)", maxNumber, longestNumber, longestChain);
        }

        private static int Hailstone(int num, Dictionary<int, int> lengths)
        {
            if (num == 1)
                return 1;

            while (true)
            {
                if (lengths.ContainsKey(num))
                    return lengths[num];

                lengths[num] = 1 + ((num%2 == 0) ? Hailstone(num/2, lengths) : Hailstone((3*num) + 1, lengths));
            }
        }
    }
}
