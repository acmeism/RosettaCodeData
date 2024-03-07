using System;
using System.Collections.Generic;
using System.Numerics;

public class SylvesterSequence
{
    public static void Main(string[] args)
    {
        BigInteger one = BigInteger.One;
        BigInteger two = new BigInteger(2);
        List<BigInteger> sylvester = new List<BigInteger> { two };
        BigInteger prod = two;
        int count = 1;

        while (count < 10)
        {
            BigInteger next = BigInteger.Add(prod, one);
            sylvester.Add(next);
            count++;
            prod *= next;
        }

        Console.WriteLine("The first 10 terms in the Sylvester sequence are:");
        foreach (var term in sylvester)
        {
            Console.WriteLine(term);
        }

        // Assuming a BigRational implementation or a workaround for the sum of reciprocals
        BigInteger denominator = BigInteger.One;
        foreach (var term in sylvester)
        {
            denominator = BigInteger.Multiply(denominator, term);
        }

        BigInteger numerator = BigInteger.Zero;
        foreach (var term in sylvester)
        {
            numerator += denominator / term;
        }

        // Assuming you have a way to convert this to a decimal representation
        Console.WriteLine("\nThe sum of their reciprocals as a rational number is:");
        Console.WriteLine($"{numerator}/{denominator}");

        // For the decimal representation, you might need to perform the division to a fixed number of decimal places
        // This is a simplified approach and may not directly achieve 211 decimal places accurately
        Console.WriteLine("\nThe sum of their reciprocals as a decimal number (to 211 places) is:");
        Console.WriteLine(DecimalDivide(numerator, denominator, 210));
    }

    private static string DecimalDivide(BigInteger numerator, BigInteger denominator, int decimalPlaces)
    {
        // This is a basic implementation and might not be accurate for very large numbers or very high precision requirements
        BigInteger quotient = BigInteger.Divide(numerator * BigInteger.Pow(10, decimalPlaces + 1), denominator);
        string quotientStr = quotient.ToString();
        string result = quotientStr.Substring(0, quotientStr.Length - decimalPlaces) + "." + quotientStr.Substring(quotientStr.Length - decimalPlaces);
        return result;
    }
}
