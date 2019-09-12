namespace RosettaCode.ArithmeticGeometricMean
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;

    internal static class Program
    {
        private static double ArithmeticGeometricMean(double number,
                                                      double otherNumber,
                                                      IEqualityComparer<double>
                                                          comparer)
        {
            return comparer.Equals(number, otherNumber)
                       ? number
                       : ArithmeticGeometricMean(
                           ArithmeticMean(number, otherNumber),
                           GeometricMean(number, otherNumber), comparer);
        }

        private static double ArithmeticMean(double number, double otherNumber)
        {
            return 0.5 * (number + otherNumber);
        }

        private static double GeometricMean(double number, double otherNumber)
        {
            return Math.Sqrt(number * otherNumber);
        }

        private static void Main()
        {
            Console.WriteLine(
                ArithmeticGeometricMean(1, 0.5 * Math.Sqrt(2),
                                        new RelativeDifferenceComparer(1e-5)).
                    ToString(CultureInfo.InvariantCulture));
        }

        private class RelativeDifferenceComparer : IEqualityComparer<double>
        {
            private readonly double _maximumRelativeDifference;

            internal RelativeDifferenceComparer(double maximumRelativeDifference)
            {
                _maximumRelativeDifference = maximumRelativeDifference;
            }

            public bool Equals(double number, double otherNumber)
            {
                return RelativeDifference(number, otherNumber) <=
                       _maximumRelativeDifference;
            }

            public int GetHashCode(double number)
            {
                return number.GetHashCode();
            }

            private static double RelativeDifference(double number,
                                                     double otherNumber)
            {
                return AbsoluteDifference(number, otherNumber) /
                       Norm(number, otherNumber);
            }

            private static double AbsoluteDifference(double number,
                                                     double otherNumber)
            {
                return Math.Abs(number - otherNumber);
            }

            private static double Norm(double number, double otherNumber)
            {
                return 0.5 * (Math.Abs(number) + Math.Abs(otherNumber));
            }
        }
    }
}
