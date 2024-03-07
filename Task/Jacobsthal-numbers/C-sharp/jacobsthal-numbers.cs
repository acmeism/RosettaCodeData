using System;
using System.Numerics;
using System.Threading;

public class JacobsthalNumbers
{
	private static BigInteger currentJacobsthal = 0;
	private static int latestIndex = 0;
	private static readonly BigInteger Three = new BigInteger(3);
	private const int Certainty = 20;
	public static void Main(string[] args)
	{
		Console.WriteLine("The first 30 Jacobsthal Numbers:");
		for (int i = 0; i < 6; i++)
		{
			for (int k = 0; k < 5; k++)
			{
				Console.Write($"{JacobsthalNumber(i * 5 + k), 15}");
			}

			Console.WriteLine();
		}

		Console.WriteLine();
		Console.WriteLine("The first 30 Jacobsthal-Lucas Numbers:");
		for (int i = 0; i < 6; i++)
		{
			for (int k = 0; k < 5; k++)
			{
				Console.Write($"{JacobsthalLucasNumber(i * 5 + k), 15}");
			}

			Console.WriteLine();
		}

		Console.WriteLine();
		Console.WriteLine("The first 20 Jacobsthal oblong Numbers:");
		for (int i = 0; i < 4; i++)
		{
			for (int k = 0; k < 5; k++)
			{
				Console.Write($"{JacobsthalOblongNumber(i * 5 + k), 15}");
			}

			Console.WriteLine();
		}

		Console.WriteLine();
		Console.WriteLine("The first 10 Jacobsthal Primes:");
		for (int i = 0; i < 10; i++)
		{
			Console.WriteLine(JacobsthalPrimeNumber());
		}
	}

	private static BigInteger JacobsthalNumber(int index)
	{
		BigInteger value = new BigInteger(ParityValue(index));
		return ((BigInteger.Parse("1") << index) - value) / Three;
	}

	private static long JacobsthalLucasNumber(int index)
	{
		return (1L << index) + ParityValue(index);
	}

	private static long JacobsthalOblongNumber(int index)
	{
		BigInteger nextJacobsthal = JacobsthalNumber(index + 1);
		long result = (long)(currentJacobsthal * nextJacobsthal);
		currentJacobsthal = nextJacobsthal;
		return result;
	}

	private static long JacobsthalPrimeNumber()
	{
		BigInteger candidate = JacobsthalNumber(latestIndex++);
		while (!candidate.IsProbablyPrime(Certainty))
		{
			candidate = JacobsthalNumber(latestIndex++);
		}

		return (long)candidate;
	}

	private static int ParityValue(int index)
	{
		return (index & 1) == 0 ? +1 : -1;
	}
}


public static class BigIntegerExtensions
{
    private static Random random = new Random();

    public static bool IsProbablyPrime(this BigInteger source, int certainty)
    {
        if (source == 2 || source == 3)
            return true;
        if (source < 2 || source % 2 == 0)
            return false;

        BigInteger d = source - 1;
        int s = 0;

        while (d % 2 == 0)
        {
            d /= 2;
            s += 1;
        }

        for (int i = 0; i < certainty; i++)
        {
            BigInteger a = RandomBigInteger(2, source - 2);
            BigInteger x = BigInteger.ModPow(a, d, source);
            if (x == 1 || x == source - 1)
                continue;

            for (int r = 1; r < s; r++)
            {
                x = BigInteger.ModPow(x, 2, source);
                if (x == 1)
                    return false;
                if (x == source - 1)
                    break;
            }

            if (x != source - 1)
                return false;
        }

        return true;
    }

    private static BigInteger RandomBigInteger(BigInteger minValue, BigInteger maxValue)
    {
        if (minValue > maxValue)
            throw new ArgumentException("minValue must be less than or equal to maxValue");

        BigInteger range = maxValue - minValue + 1;
        int length = range.ToByteArray().Length;
        byte[] buffer = new byte[length];

        BigInteger result;
        do
        {
            random.NextBytes(buffer);
            buffer[buffer.Length - 1] &= 0x7F; // Ensure non-negative
            result = new BigInteger(buffer);
        } while (result < minValue || result >= maxValue);

        return result;
    }
}
