static Random tRand = new Random();

static void Main(string[] args)
{
	double[] a = new double[1000];

	double tAvg = 0;
	for (int x = 0; x < a.Length; x++)
	{
		a[x] = randomNormal() / 2 + 1;
		tAvg += a[x];
	}

	tAvg /= a.Length;
	Console.WriteLine("Average: " + tAvg.ToString());

	double s = 0;
	for (int x = 0; x < a.Length; x++)
	{
		s += Math.Pow((a[x] - tAvg), 2);
	}
	s = Math.Sqrt(s / 1000);

	Console.WriteLine("Standard Deviation: " + s.ToString());

	Console.ReadLine();
}
