using System;
using System.Collections.Generic;
using System.Numerics;

public class DistributionInFactorials
{
    public static void Main(string[] args)
    {
        List<int> limits = new List<int> { 100, 1_000, 10_000 };
        foreach (int limit in limits)
        {
            MeanFactorialDigits(limit);
        }
    }

    private static void MeanFactorialDigits(int limit)
    {
        BigInteger factorial = BigInteger.One;
        double proportionSum = 0.0;
        double proportionMean = 0.0;

        for (int n = 1; n <= limit; n++)
        {
            factorial = factorial * n;
            string factorialString = factorial.ToString();
            int digitCount = factorialString.Length;
            long zeroCount = factorialString.Split('0').Length - 1;
            proportionSum += (double)zeroCount / digitCount;
            proportionMean = proportionSum / n;
        }

        string result = string.Format("{0:F8}", proportionMean);
        Console.WriteLine("Mean proportion of zero digits in factorials from 1 to " + limit + " is " + result);
    }
}
