static void Main(string[] args)
{
	Console.WriteLine("Perfect numbers from 1 to 33550337:");

	for (int x = 0; x < 33550337; x++)
	{
		if (IsPerfect(x))
			Console.WriteLine(x + " is perfect.");
	}

	Console.ReadLine();
}

static bool IsPerfect(int num)
{
	return Enumerable.Range(1, num - 1).Sum(n => num % n == 0 ? n : 0 ) == num;
}
