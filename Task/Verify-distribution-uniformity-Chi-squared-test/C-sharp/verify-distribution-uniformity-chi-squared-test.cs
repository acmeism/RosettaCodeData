using System;

class Program
{
	public delegate double Func(double x);
	public static double Simpson38(Func f, double a, double b, int n)
	{
		double h = (b - a) / n;
		double h1 = h / 3;
		double sum = f(a) + f(b);
		for (int j = 3 * n - 1; j > 0; j--)
		{
			if (j % 3 == 0)
			{
				sum += 2 * f(a + h1 * j);
			}
			else
			{
				sum += 3 * f(a + h1 * j);
			}
		}

		return h * sum / 8;
	}

	// Lanczos Approximation for Gamma Function
	private static double SpecialFunctionGamma(double z)
	{
		double[] p =
		{
			676.5203681218851,
			-1259.1392167224028,
			771.32342877765313,
			-176.61502916214059,
			12.507343278686905,
			-0.13857109526572012,
			9.9843695780195716e-6,
			1.5056327351493116e-7
		};
		if (z < 0.5)
			return Math.PI / (Math.Sin(Math.PI * z) * SpecialFunctionGamma(1 - z));
		z -= 1;
		double x = 0.99999999999980993;
		for (int i = 0; i < p.Length; i++)
		{
			x += p[i] / (z + i + 1);
		}

		double t = z + p.Length - 0.5;
		return Math.Sqrt(2 * Math.PI) * Math.Pow(t, z + 0.5) * Math.Exp(-t) * x;
	}

	public static double GammaIncQ(double a, double x)
	{
		double aa1 = a - 1;
		Func f = t => Math.Pow(t, aa1) * Math.Exp(-t);
		double y = aa1;
		double h = 1.5e-2;
		while (f(y) * (x - y) > 2e-8 && y < x)
		{
			y += .4;
		}

		if (y > x)
		{
			y = x;
		}

		return 1 - Simpson38(f, 0, y, (int)(y / h / SpecialFunctionGamma(a)));
	}

	public static double Chi2Ud(int[] ds)
	{
		double sum = 0, expected = 0;
		foreach (var d in ds)
		{
			expected += d;
		}

		expected /= ds.Length;
		foreach (var d in ds)
		{
			double x = d - expected;
			sum += x * x;
		}

		return sum / expected;
	}

	public static double Chi2P(int dof, double distance)
	{
		return GammaIncQ(.5 * dof, .5 * distance);
	}

	const double SigLevel = .05;
	static void Main(string[] args)
	{
		int[][] datasets = new int[][]
		{
			new int[]
			{
				199809,
				200665,
				199607,
				200270,
				199649
			},
			new int[]
			{
				522573,
				244456,
				139979,
				71531,
				21461
			},
		};
		foreach (var dset in datasets)
		{
			UTest(dset);
		}
	}

	static void UTest(int[] dset)
	{
		Console.WriteLine("Uniform distribution test");
		int sum = 0;
		foreach (var c in dset)
		{
			sum += c;
		}

		Console.WriteLine($" dataset: {string.Join(", ", dset)}");
		Console.WriteLine($" samples:                      {sum}");
		Console.WriteLine($" categories:                   {dset.Length}");
		int dof = dset.Length - 1;
		Console.WriteLine($" degrees of freedom:           {dof}");
		double dist = Chi2Ud(dset);
		Console.WriteLine($" chi square test statistic:    {dist}");
		double p = Chi2P(dof, dist);
		Console.WriteLine($" p-value of test statistic:    {p}");
		bool sig = p < SigLevel;
		Console.WriteLine($" significant at {SigLevel * 100}% level?      {sig}");
		Console.WriteLine($" uniform?                      {!sig}\n");
	}
}
