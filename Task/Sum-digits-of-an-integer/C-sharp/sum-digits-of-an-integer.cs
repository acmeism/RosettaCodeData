namespace RosettaCode.SumDigitsOfAnInteger
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    internal static class Program
    {
        /// <summary>
        ///     Enumerates the digits of a number in a given base.
        /// </summary>
        /// <param name="number"> The number. </param>
        /// <param name="base"> The base. </param>
        /// <returns> The digits of the number in the given base. </returns>
        /// <remarks>
        ///     The digits are enumerated from least to most significant.
        /// </remarks>
        private static IEnumerable<int> Digits(this int number, int @base = 10)
        {
            while (number != 0)
            {
                int digit;
                number = Math.DivRem(number, @base, out digit);
                yield return digit;
            }
        }

        /// <summary>
        ///     Sums the digits of a number in a given base.
        /// </summary>
        /// <param name="number"> The number. </param>
        /// <param name="base"> The base. </param>
        /// <returns> The sum of the digits of the number in the given base. </returns>
        private static int SumOfDigits(this int number, int @base = 10)
        {
            return number.Digits(@base).Sum();
        }

        /// <summary>
        ///     Demonstrates <see cref="SumOfDigits" />.
        /// </summary>
        private static void Main()
        {
            foreach (var example in
                new[]
                {
                    new {Number = 1, Base = 10},
                    new {Number = 12345, Base = 10},
                    new {Number = 123045, Base = 10},
                    new {Number = 0xfe, Base = 0x10},
                    new {Number = 0xf0e, Base = 0x10}
                })
            {
                Console.WriteLine(example.Number.SumOfDigits(example.Base));
            }
        }
    }
}
