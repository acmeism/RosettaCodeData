namespace RosettaCode.Arithmetic.Complex
{
    using System;
    using System.Numerics;

    internal static class Program
    {
        private static void Main()
        {
            var number = Complex.ImaginaryOne;
            foreach (var result in new[] { number + number, number * number, -number, 1 / number, Complex.Conjugate(number) })
            {
                Console.WriteLine(result);
            }
        }
    }
}
