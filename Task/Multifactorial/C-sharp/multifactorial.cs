namespace RosettaCode.Multifactorial
{
    using System;
    using System.Linq;

    internal static class Program
    {
        private static void Main()
        {
            Console.WriteLine(string.Join(Environment.NewLine,
                                          Enumerable.Range(1, 5)
                                                    .Select(
                                                        degree =>
                                                        string.Join(" ",
                                                                    Enumerable.Range(1, 10)
                                                                              .Select(
                                                                                  number =>
                                                                                  Multifactorial(number, degree))))));
        }

        private static int Multifactorial(int number, int degree)
        {
            if (degree < 1)
            {
                throw new ArgumentOutOfRangeException("degree");
            }

            var count = 1 + (number - 1) / degree;
            if (count < 1)
            {
                throw new ArgumentOutOfRangeException("number");
            }

            return Enumerable.Range(0, count)
                             .Aggregate(1, (accumulator, index) => accumulator * (number - degree * index));
        }
    }
}
