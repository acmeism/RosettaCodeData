using System;
using System.Collections.Generic;
using System.Linq;

namespace RosettaCode.AmicablePairs
{
    internal static class Program {
        private const int Limit = 20000;

        private static void Main()
        {
            foreach (var pair in GetPairs(Limit))
            {
                Console.WriteLine("{0} {1}", pair.Item1, pair.Item2);
            }
        }

        private static IEnumerable<Tuple<int, int>> GetPairs(int max)
        {
            List<int> divsums =
                Enumerable.Range(0, max + 1).Select(i => ProperDivisors(i).Sum()).ToList();
            for(int i=1; i<divsums.Count; i++) {
                int sum = divsums[i];
                if(i < sum && sum <= divsums.Count && divsums[sum] == i) {
                    yield return new Tuple<int, int>(i, sum);
                }
            }
        }

        private static IEnumerable<int> ProperDivisors(int number)
        {
            return
                Enumerable.Range(1, number / 2)
                    .Where(divisor => number % divisor == 0);
        }
    }
}
