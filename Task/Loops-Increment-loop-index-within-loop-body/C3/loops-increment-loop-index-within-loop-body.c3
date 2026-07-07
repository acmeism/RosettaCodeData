module rosettacode;

import std::io;

fn bool is_prime(long n)
{
	if (n % 2 == 0) return n == 2;
	if (n % 3 == 0) return n == 3;
	long d = 5;
	while (d * d <= n)
	{
		if (n % d == 0) return false;
		d += 2;
		if (n % d == 0) return false;
		d += 4;
	}
	return true;
}

fn int main(String[] args)
{
	const LIMIT = 42;
	int n;
	for (int i = LIMIT, n = 0; n < LIMIT; i++)
	{
		if (is_prime(i))
		{
			n++;
			io::printf("n = %-2d %19d\n", n, i);
			i += i - 1;
		}
	}
	return 0;
}
