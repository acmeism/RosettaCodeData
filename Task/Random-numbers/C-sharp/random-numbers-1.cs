private static double randomNormal()
{
	return Math.Cos(2 * Math.PI * tRand.NextDouble()) * Math.Sqrt(-2 * Math.Log(tRand.NextDouble()));
}
