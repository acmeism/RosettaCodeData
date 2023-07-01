static void Main(string[] args)
{
	int p;

	p = 1;
	Console.WriteLine("Ref Before: " + p);
	Value(ref p);
	Console.WriteLine("Ref After : " + p);

	p = 1;
	Console.WriteLine("Val Before: " + p);
	Value(p);
	Console.WriteLine("Val After : " + p);

	Console.ReadLine();
}

private static void Value(ref int Value)
{
	Value += 1;
}
private static void Value(int Value)
{
	Value += 1;
}
