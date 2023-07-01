using System;
using System.Console;
using System.Linq;
using MathNet.Numerics;

namespace Rosettacode.Rational.CS
{
    class Program
    {
        private static readonly Func<int, BigRational> ℚ = BigRational.FromInt;

        private static BigRational CalculateBernoulli(int n)
        {
            var a = InitializeArray(n);

            foreach(var m in Enumerable.Range(1,n))
            {
                a[m] = ℚ(1) / (ℚ(m) + ℚ(1));

                for (var j = m; j >= 1; j--)
                {
                    a[j-1] = ℚ(j) * (a[j-1] - a[j]);
                }
            }

            return a[0];
        }

        private static BigRational[] InitializeArray(int n)
        {
            var a = new BigRational[n + 1];

            for (var x = 0; x < a.Length; x++)
            {
                a[x] = ℚ(x + 1);
            }

            return a;
        }

        static void Main()
        {
            Enumerable.Range(0, 61) // the second parameter is the number of range elements, and is not the final item of the range.
                .Select(n => new {N = n, BernoulliNumber = CalculateBernoulli(n)})
                .Where(b => !b.BernoulliNumber.Numerator.IsZero)
                .Select(b => string.Format("B({0, 2}) = {1, 44} / {2}", b.N, b.BernoulliNumber.Numerator, b.BernoulliNumber.Denominator))
                .ToList()
                .ForEach(WriteLine);
        }
    }
}
