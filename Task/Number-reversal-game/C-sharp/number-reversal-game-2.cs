class Program
{
	static void Main(string[] args)
	{
		int[] values = new int[9];
		Random tRandom = new Random();
		int tries = 0;

		for (int x = 0; x < values.Length; x++)
		{
			values[x] = x + 1;
		}

		values = RandomPermutation<int>(values);

		do
		{
			Console.Write("Numbers: ");
			for (int x = 0; x < values.Length; x++)
			{
				Console.Write(" ");
				Console.Write(values[x]);
			}
			Console.WriteLine(". Enter number of numbers from the left to reverse: ");

			string tIn = "";
			do
			{
				tIn = Console.ReadLine();
			} while (tIn.Length != 1);

			int nums = Convert.ToInt32(tIn.ToString());

			int[] newValues = new int[9];
			for (int x = nums; x < newValues.Length; x++)
			{
				// Move those not reversing
				newValues[x] = values[x];
			}
			for (int x = 0; x < nums; x++)
			{
				// Reverse the rest
				newValues[x] = values[nums - 1 - x];
			}
			values = newValues;
			tries++;
		} while (!check(values));

		Console.WriteLine("Success!");
		Console.WriteLine("Attempts: " + tries);

		Console.Read();
	}

	public static bool check(int[] p)
	{
		// Check all items
		for (int x = 0; x < p.Length - 1; x++)
		{
			if (p[x + 1] <= p[x])
				return false;
		}

		return true;
	}

	public static T[] RandomPermutation<T>(T[] array)
	{
		T[] retArray = new T[array.Length];
		array.CopyTo(retArray, 0);

		Random random = new Random();
		for (int i = 0; i < array.Length; i += 1)
		{
			int swapIndex = random.Next(i, array.Length);
			if (swapIndex != i)
			{
				T temp = retArray[i];
				retArray[i] = retArray[swapIndex];
				retArray[swapIndex] = temp;
			}
		}

		return retArray;
	}
}
