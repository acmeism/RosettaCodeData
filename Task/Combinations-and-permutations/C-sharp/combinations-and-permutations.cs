using System;
using System.Numerics;

class CombinationsAndPermutations
{
	public static void Main(string[] args)
	{
		Console.WriteLine(double.MaxValue);
		Console.WriteLine("A sample of permutations from 1 to 12 with exact Integer arithmetic:");
		for (int n = 1; n <= 12; n++)
		{
			int k = n / 2;
			Console.WriteLine($"{n} P {k} = {Permutation(n, k)}");
		}

		Console.WriteLine();
		Console.WriteLine("A sample of combinations from 10 to 60 with exact Integer arithmetic:");
		for (int n = 10; n <= 60; n += 5)
		{
			int k = n / 2;
			Console.WriteLine($"{n} C {k} = {Combination(n, k)}");
		}

		Console.WriteLine();
		Console.WriteLine("A sample of permutations from 5 to 15000 displayed in floating point arithmetic:");
		Console.WriteLine($"{5} P {2} = {Display(Permutation(5, 2), 50)}");
		for (int n = 1000; n <= 15000; n += 1000)
		{
			int k = n / 2;
			Console.WriteLine($"{n} P {k} = {Display(Permutation(n, k), 50)}");
		}

		Console.WriteLine();
		Console.WriteLine("A sample of combinations from 100 to 1000 displayed in floating point arithmetic:");
		for (int n = 100; n <= 1000; n += 100)
		{
			int k = n / 2;
			Console.WriteLine($"{n} C {k} = {Display(Combination(n, k), 50)}");
		}
	}

	private static string Display(BigInteger val, int precision)
	{
		string s = val.ToString();
		// Ensure that we don't try to take a substring longer than what's available.
		int actualPrecision = Math.Min(precision, s.Length - 1); // Adjusted to ensure it doesn't exceed string length
		System.Text.StringBuilder sb = new System.Text.StringBuilder();
		if (s.Length > 1) // Check if the string has more than one character
		{
			sb.Append(s.Substring(0, 1));
			sb.Append(".");
			sb.Append(s.Substring(1, actualPrecision-1));
		}
		else
		{
			// If the string is only one digit, no need to insert a decimal point.
			sb.Append(s);
		}

		sb.Append(" * 10^");
		sb.Append(s.Length - 1);
		return sb.ToString();
	}

	public static BigInteger Combination(int n, int k)
	{
		// Select value with smallest intermediate results
		// combination(n, k) = combination(n, n-k)
		if (n - k < k)
		{
			k = n - k;
		}

		BigInteger result = Permutation(n, k);
		while (k > 0)
		{
			result = result / k;
			k--;
		}

		return result;
	}

	public static BigInteger Permutation(int n, int k)
	{
		BigInteger result = BigInteger.One;
		for (int i = n; i >= n - k + 1; i--)
		{
			result = result * i;
		}

		return result;
	}
}
