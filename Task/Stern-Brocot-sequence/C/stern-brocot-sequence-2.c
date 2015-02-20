uint f(uint n)
{
	uint a = 1, b = 0;
	while (n) {
		if (n&1) b += a;
		else	 a += b;
		n >>= 1;
	}
	return b;
}
