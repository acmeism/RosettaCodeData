using System;
using System.Collections.Generic;
using System.Linq;

namespace standardDeviation
{
    class Program
    {
        static void Main(string[] args)
        {
            List<double> nums = new List<double> { 2, 4, 4, 4, 5, 5, 7, 9 };
            for (int i = 1; i <= nums.Count; i++)
                Console.WriteLine(sdev(nums.GetRange(0, i)));
        }

        static double sdev(List<double> nums)
        {
            List<double> store = new List<double>();
            foreach (double n in nums)
                store.Add((n - nums.Average()) * (n - nums.Average()));

            return Math.Sqrt(store.Sum() / store.Count);
        }
    }
}
