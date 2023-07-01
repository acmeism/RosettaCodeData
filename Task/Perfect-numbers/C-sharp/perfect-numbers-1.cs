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
	int sum = 0;
	for (int i = 1; i < num; i++)
	{
		if (num % i == 0)
			sum += i;
	}

	return sum == num ;
}
