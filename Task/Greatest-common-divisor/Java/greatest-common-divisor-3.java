public static int gcd(int a, int b) //valid for positive integers.
{
	while(b > 0)
	{
		int c = a % b;
		a = b;
		b = c;
	}
	return a;
}
