using System;
using System.Collections.Generic;
using System.Numerics;

public class JugglerSequence
{
    public static void Main(string[] args)
    {
        Console.WriteLine(" n    l[n]  i[n]             h[n]");
        Console.WriteLine("---------------------------------");
        for (int number = 20; number <= 39; number++)
        {
            JugglerData result = Juggler(number);
            Console.WriteLine($"{number,2}{result.Count,7}{result.MaxCount,6}{result.MaxNumber,17}");
        }
        Console.WriteLine();

        List<int> values = new List<int> { 113, 173, 193, 2183, 11229, 15065, 15845, 30817 };
        Console.WriteLine("    n     l[n]   i[n]   d[n]");
        Console.WriteLine("----------------------------");
        foreach (int value in values)
        {
            JugglerData result = Juggler(value);
            Console.WriteLine($"{value,5}{result.Count,8}{result.MaxCount,7}{result.DigitCount,7}");
        }
    }

    private static JugglerData Juggler(int number)
    {
        if (number < 1)
        {
            throw new ArgumentException("Starting value must be >= 1: " + number);
        }
        BigInteger bigNumber = new BigInteger(number);
        int count = 0;
        int maxCount = 0;
        BigInteger maxNumber = bigNumber;
        while (!bigNumber.Equals(BigInteger.One))
{
    if (bigNumber.IsEven)
    {
        bigNumber = bigNumber.Sqrt();
    }
    else
    {
        BigInteger cubed = BigInteger.Pow(bigNumber, 3);
        bigNumber = cubed.Sqrt(); // Approximating the cube root by taking the square root of the cubed value.
    }
    count++;
    if (bigNumber.CompareTo(maxNumber) > 0)
    {
        maxNumber = bigNumber;
        maxCount = count;
    }
}

        return new JugglerData(count, maxCount, maxNumber, maxNumber.ToString().Length);
    }

    private class JugglerData
    {
        public int Count { get; }
        public int MaxCount { get; }
        public BigInteger MaxNumber { get; }
        public int DigitCount { get; }

        public JugglerData(int count, int maxCount, BigInteger maxNumber, int digitCount)
        {
            Count = count;
            MaxCount = maxCount;
            MaxNumber = maxNumber;
            DigitCount = digitCount;
        }
    }
}

public static class BigIntegerExtensions
{
    public static BigInteger Sqrt(this BigInteger n)
    {
        if (n == 0) return 0;
        if (n > 0)
        {
            int bitLength = Convert.ToInt32(Math.Ceiling(BigInteger.Log(n, 2)));
            BigInteger root = BigInteger.One << (bitLength / 2);

            while (!IsSqrt(n, root))
            {
                root += n / root;
                root /= 2;
            }

            return root;
        }
        throw new ArithmeticException("NaN");
    }

    private static bool IsSqrt(BigInteger n, BigInteger root)
    {
        BigInteger lowerBound = root * root;
        BigInteger upperBound = (root + 1) * (root + 1);
        return n >= lowerBound && n < upperBound;
    }
}
