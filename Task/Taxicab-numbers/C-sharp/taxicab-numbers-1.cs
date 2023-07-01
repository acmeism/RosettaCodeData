using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TaxicabNumber
{
    class Program
    {
        static void Main(string[] args)
        {
            IDictionary<long, IList<Tuple<int, int>>> taxicabNumbers = GetTaxicabNumbers(2006);
            PrintTaxicabNumbers(taxicabNumbers);
            Console.ReadKey();
        }

        private static IDictionary<long, IList<Tuple<int, int>>> GetTaxicabNumbers(int length)
        {
            SortedList<long, IList<Tuple<int, int>>> sumsOfTwoCubes = new SortedList<long, IList<Tuple<int, int>>>();

            for (int i = 1; i < int.MaxValue; i++)
            {
                for (int j = 1; j < int.MaxValue; j++)
                {
                    long sum = (long)(Math.Pow((double)i, 3) + Math.Pow((double)j, 3));

                    if (!sumsOfTwoCubes.ContainsKey(sum))
                    {
                        sumsOfTwoCubes.Add(sum, new List<Tuple<int, int>>());
                    }

                    sumsOfTwoCubes[sum].Add(new Tuple<int, int>(i, j));

                    if (j >= i)
                    {
                        break;
                    }
                }

                // Found that you need to keep going for a while after the length, because higher i values fill in gaps
                if (sumsOfTwoCubes.Count(t => t.Value.Count >= 2) >= length * 1.1)
                {
                    break;
                }
            }

            IDictionary<long, IList<Tuple<int, int>>> values = (from t in sumsOfTwoCubes where t.Value.Count >= 2 select t)
                .Take(2006)
                .ToDictionary(u => u.Key, u => u.Value);

            return values;
        }

        private static void PrintTaxicabNumbers(IDictionary<long, IList<Tuple<int, int>>> values)
        {
            int i = 1;

            foreach (long taxicabNumber in values.Keys)
            {
                StringBuilder output = new StringBuilder().AppendFormat("{0,10}\t{1,4}", i, taxicabNumber);

                foreach (Tuple<int, int> numbers in values[taxicabNumber])
                {
                    output.AppendFormat("\t= {0}^3 + {1}^3", numbers.Item1, numbers.Item2);
                }

                if (i <= 25 || (i >= 2000 && i <= 2006))
                {
                    Console.WriteLine(output.ToString());
                }

                i++;
            }
        }
    }
}
