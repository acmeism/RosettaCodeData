using System;
using System.Numerics;

public class BigRational
{
    public BigInteger Numerator { get; private set; }
    public BigInteger Denominator { get; private set; }

    public BigRational(BigInteger numerator, BigInteger denominator)
    {
        if (denominator == 0)
            throw new ArgumentException("Denominator cannot be zero.", nameof(denominator));

        BigInteger gcd = BigInteger.GreatestCommonDivisor(numerator, denominator);
        Numerator = numerator / gcd;
        Denominator = denominator / gcd;

        if (Denominator < 0)
        {
            Numerator = -Numerator;
            Denominator = -Denominator;
        }
    }

    public static BigRational operator +(BigRational a, BigRational b)
    {
        return new BigRational(a.Numerator * b.Denominator + b.Numerator * a.Denominator, a.Denominator * b.Denominator);
    }

    public override string ToString()
    {
        return $"{Numerator}/{Denominator}";
    }
}

class Program
{
    static BigRational Harmonic(int n)
    {
        BigRational sum = new BigRational(0, 1);
        for (int i = 1; i <= n; i++)
        {
            BigRational r = new BigRational(1, i);
            sum += r;
        }
        return sum;
    }

    static void Main(string[] args)
    {
        Console.WriteLine("The first 20 harmonic numbers and the 100th, expressed in rational form, are:");
        int[] numbers = new int[21];
        for (int i = 1; i <= 20; i++)
        {
            numbers[i - 1] = i;
        }
        numbers[20] = 100;
        foreach (int i in numbers)
        {
            Console.WriteLine($"{i,3} : {Harmonic(i)}");
        }

        Console.WriteLine("\nThe first harmonic number to exceed the following integers is:");
        const int limit = 10;
        for (int i = 1, n = 1; i <= limit; n++)
        {
            double h = 0;
            for (int j = 1; j <= n; j++)
            {
                h += 1.0 / j;
            }
            if (h > i)
            {
                Console.WriteLine($"integer = {i,2}  -> n = {n,6}  ->  harmonic number = {h,9:F6} (to 6dp)");
                i++;
            }
        }
    }
}
