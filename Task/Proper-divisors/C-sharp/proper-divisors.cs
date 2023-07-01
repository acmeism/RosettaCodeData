namespace RosettaCode.ProperDivisors
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    internal static class Program
    {
        private static IEnumerable<int> ProperDivisors(int number)
        {
            return
                Enumerable.Range(1, number / 2)
                    .Where(divisor => number % divisor == 0);
        }

        private static void Main()
        {
            foreach (var number in Enumerable.Range(1, 10))
            {
                Console.WriteLine("{0}: {{{1}}}", number,
                    string.Join(", ", ProperDivisors(number)));
            }

            var record = Enumerable.Range(1, 20000).Select(number => new
            {
                Number = number,
                Count = ProperDivisors(number).Count()
            }).OrderByDescending(currentRecord => currentRecord.Count).First();
            Console.WriteLine("{0}: {1}", record.Number, record.Count);
        }
    }
}
