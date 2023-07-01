static void Main(string[] args)
{
	Console.WriteLine("5^5 = " + Expon(5, 5));
	Console.WriteLine("5.5^5 = " + Expon(5.5, 5));
	Console.ReadLine();
}

static double Expon(int Val, int Pow)
{
	return Math.Pow(Val, Pow);
}
static double Expon(double Val, int Pow)
{
	return Math.Pow(Val, Pow);
}
