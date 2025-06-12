using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public static class PAdicNumbersBasic
{
    public static void Main(string[] args)
    {
        Console.WriteLine("3-adic numbers:");
        Padic padicOne = new Padic(3, -5, 9);
        Console.WriteLine("-5 / 9    => " + padicOne);
        Padic padicTwo = new Padic(3, 47, 12);
        Console.WriteLine("47 / 12   => " + padicTwo);

        Padic sum = padicOne.Add(padicTwo);
        Console.WriteLine("sum       => " + sum);
        Console.WriteLine("Rational = " + sum.ConvertToRational());
        Console.WriteLine();

        Console.WriteLine("7-adic numbers:");
        padicOne = new Padic(7, 5, 8);
        Console.WriteLine("5 / 8         => " + padicOne);
        padicTwo = new Padic(7, 353, 30809);
        Console.WriteLine("353 / 30809   => " + padicTwo);

        sum = padicOne.Add(padicTwo);
        Console.WriteLine("sum           => " + sum);
        Console.WriteLine("Rational = " + sum.ConvertToRational());
    }
}

public sealed class Padic
{
    /**
     * Create a p-adic, with p = aPrime, from the given rational 'aNumerator' / 'aDenominator'.
     */
    public Padic(int aPrime, int aNumerator, int aDenominator)
    {
        if (aDenominator == 0)
        {
            throw new ArgumentException("Denominator cannot be zero");
        }

        prime = aPrime;
        digits = new List<int>(DIGITS_SIZE);
        order = 0;

        // Process rational zero
        if (aNumerator == 0)
        {
            order = MAX_ORDER;
            return;
        }

        // Remove multiples of 'prime' and adjust the order of the p-adic number accordingly
        while (FloorMod(aNumerator, prime) == 0)
        {
            aNumerator /= prime;
            order += 1;
        }

        while (FloorMod(aDenominator, prime) == 0)
        {
            aDenominator /= prime;
            order -= 1;
        }

        // Standard calculation of p-adic digits
        long inverse = ModuloInverse(aDenominator);
        while (digits.Count < DIGITS_SIZE)
        {
            int digit = FloorMod((int)(aNumerator * inverse), prime);
            digits.Add(digit);

            aNumerator -= digit * aDenominator;

            if (aNumerator != 0)
            {
                // The denominator is not a power of a prime
                int count = 0;
                while (FloorMod(aNumerator, prime) == 0)
                {
                    aNumerator /= prime;
                    count += 1;
                }

                for (int i = count; i > 1; i--)
                {
                    digits.Add(0);
                }
            }
        }
    }

    /**
     * Return the sum of this p-adic number and the given p-adic number.
     */
    public Padic Add(Padic aOther)
    {
        if (prime != aOther.prime)
        {
            throw new ArgumentException("Cannot add p-adic's with different primes");
        }

        List<int> result = new List<int>();

        // Adjust the digits so that the p-adic points are aligned
        for (int i = 0; i < -order + aOther.order; i++)
        {
            aOther.digits.Insert(0, 0);
        }

        for (int i = 0; i < -aOther.order + order; i++)
        {
            digits.Insert(0, 0);
        }

        // Standard digit by digit addition
        int carry = 0;
        for (int i = 0; i < Math.Min(digits.Count, aOther.digits.Count); i++)
        {
            int sum = digits[i] + aOther.digits[i] + carry;
            int remainder = FloorMod(sum, prime);
            carry = (sum >= prime) ? 1 : 0;
            result.Add(remainder);
        }

        // Reverse the changes made to the digits
        for (int i = 0; i < -order + aOther.order; i++)
        {
            aOther.digits.RemoveAt(0);
        }

        for (int i = 0; i < -aOther.order + order; i++)
        {
            digits.RemoveAt(0);
        }

        return new Padic(prime, result, AllZeroDigits(result) ? MAX_ORDER : Math.Min(order, aOther.order));
    }

    /**
     * Return the Rational representation of this p-adic number.
     */
    public Rational ConvertToRational()
    {
        List<int> numbers = new List<int>(digits);

        // Zero
        if (numbers.Count == 0 || AllZeroDigits(numbers))
        {
            return new Rational(0, 1);
        }

        // Positive integer
        if (order >= 0 && EndsWith(numbers, 0))
        {
            for (int i = 0; i < order; i++)
            {
                numbers.Insert(0, 0);
            }

            return new Rational(ConvertToDecimal(numbers), 1);
        }

        // Negative integer
        if (order >= 0 && EndsWith(numbers, prime - 1))
        {
            NegateList(numbers);
            for (int i = 0; i < order; i++)
            {
                numbers.Insert(0, 0);
            }

            return new Rational(-ConvertToDecimal(numbers), 1);
        }

        // Rational
        Padic sum = new Padic(prime, new List<int>(digits), order);
        Padic self = new Padic(prime, new List<int>(digits), order);
        int denominator = 1;
        do
        {
            sum = sum.Add(self);
            denominator += 1;
        } while (!(EndsWith(sum.digits, 0) || EndsWith(sum.digits, prime - 1)));

        bool negative = EndsWith(sum.digits, prime - 1);
        if (negative)
        {
            NegateList(sum.digits);
        }

        int numerator = negative ? -ConvertToDecimal(sum.digits) : ConvertToDecimal(sum.digits);

        if (order > 0)
        {
            numerator *= (int)Math.Pow(prime, order);
        }

        if (order < 0)
        {
            denominator *= (int)Math.Pow(prime, -order);
        }

        return new Rational(numerator, denominator);
    }

    /**
     * Return a string representation of this p-adic.
     */
    public override string ToString()
    {
        List<int> numbers = new List<int>(digits);
        PadWithZeros(numbers);
        numbers.Reverse();
        string numberString = string.Join("", numbers.Select(n => n.ToString()));
        StringBuilder builder = new StringBuilder(numberString);

        if (order >= 0)
        {
            for (int i = 0; i < order; i++)
            {
                builder.Append("0");
            }

            builder.Append(".0");
        }
        else
        {
            builder.Insert(builder.Length + order, ".");

            while (builder.ToString().EndsWith("0"))
            {
                builder.Remove(builder.Length - 1, 1);
            }
        }

        return " ..." + builder.ToString().Substring(builder.Length - PRECISION - 1);
    }

    // PRIVATE //

    /**
     * Create a p-adic, with p = 'aPrime', directly from a list of digits.
     *
     * With 'aOrder' = 0, the list [1, 2, 3, 4, 5] creates the p-adic ...54321.0
     * 'aOrder' > 0 shifts the list 'aOrder' places to the left and
     * 'aOrder' < 0 shifts the list 'aOrder' places to the right.
     */
    private Padic(int aPrime, List<int> aDigits, int aOrder)
    {
        prime = aPrime;
        digits = new List<int>(aDigits);
        order = aOrder;
    }

    /**
     * Return the multiplicative inverse of the given decimal number modulo 'prime'.
     */
    private int ModuloInverse(int aNumber)
    {
        int inverse = 1;
        while (FloorMod(inverse * aNumber, prime) != 1)
        {
            inverse += 1;
        }

        return inverse;
    }

    /**
     * Transform the given list of digits representing a p-adic number
     * into a list which represents the negation of the p-adic number.
     */
    private void NegateList(List<int> aDigits)
    {
        aDigits[0] = FloorMod(prime - aDigits[0], prime);
        for (int i = 1; i < aDigits.Count; i++)
        {
            aDigits[i] = prime - 1 - aDigits[i];
        }
    }

    /**
     * Return the given list of base 'prime' integers converted to a decimal integer.
     */
    private int ConvertToDecimal(List<int> aNumbers)
    {
        int decimal_value = 0;
        int multiple = 1;
        foreach (int number in aNumbers)
        {
            decimal_value += number * multiple;
            multiple *= prime;
        }

        return decimal_value;
    }

    /**
     * Return whether the given list consists of all zeros.
     */
    private static bool AllZeroDigits(List<int> aList)
    {
        return aList.All(i => i == 0);
    }

    /**
     * The given list is padded on the right by zeros up to a maximum length of 'PRECISION'.
     */
    private static void PadWithZeros(List<int> aList)
    {
        while (aList.Count < DIGITS_SIZE)
        {
            aList.Add(0);
        }
    }

    /**
     * Return whether the given list ends with multiple instances of the given number.
     */
    private static bool EndsWith(List<int> aDigits, int aDigit)
    {
        for (int i = aDigits.Count - 1; i >= aDigits.Count - PRECISION / 2; i--)
        {
            if (aDigits[i] != aDigit)
            {
                return false;
            }
        }

        return true;
    }

    /**
     * C# implementation of Java's Math.floorMod
     */
    private static int FloorMod(int x, int y)
    {
        int r = x % y;
        // If the signs are different and modulo not zero, adjust result
        if ((x ^ y) < 0 && r != 0)
        {
            r += y;
        }
        return r;
    }

    public class Rational
    {
        private int numerator;
        private int denominator;

        public Rational(int aNumerator, int aDenominator)
        {
            if (aDenominator < 0)
            {
                numerator = -aNumerator;
                denominator = -aDenominator;
            }
            else
            {
                numerator = aNumerator;
                denominator = aDenominator;
            }

            if (aNumerator == 0)
            {
                denominator = 1;
            }

            int gcd = GCD(numerator, denominator);
            numerator /= gcd;
            denominator /= gcd;
        }

        public override string ToString()
        {
            return numerator + " / " + denominator;
        }

        private int GCD(int aOne, int aTwo)
        {
            if (aTwo == 0)
            {
                return Math.Abs(aOne);
            }
            return GCD(aTwo, FloorMod(aOne, aTwo));
        }
    }

    private List<int> digits;
    private int order;

    private readonly int prime;

    private const int MAX_ORDER = 1000;
    private const int PRECISION = 40;
    private const int DIGITS_SIZE = PRECISION + 5;
}
