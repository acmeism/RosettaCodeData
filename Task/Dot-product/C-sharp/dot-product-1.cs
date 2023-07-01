static void Main(string[] args)
{
	Console.WriteLine(DotProduct(new decimal[] { 1, 3, -5 }, new decimal[] { 4, -2, -1 }));
	Console.Read();
}

private static decimal DotProduct(decimal[] vec1, decimal[] vec2)
{
	if (vec1 == null)
		return 0;

	if (vec2 == null)
		return 0;

	if (vec1.Length != vec2.Length)
		return 0;

	decimal tVal = 0;
	for (int x = 0; x < vec1.Length; x++)
	{
		tVal += vec1[x] * vec2[x];
	}

	return tVal;
}
