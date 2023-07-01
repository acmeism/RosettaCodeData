static void Main()
{
	IEnumerable<BigInteger[]> triangle = PascalsTriangle.GetTriangle(20);
	string output = PascalsTriangle.FormatTriangleString(triangle)
	Console.WriteLine(output);
}
