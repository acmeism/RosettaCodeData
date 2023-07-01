int main()
{
	int j;
	ulong fac[10000], n, sum;

	sieve();

	for (n = 2; n < 33550337; n++) {
		j = get_factors(n, fac) - 1;
		for (sum = 0; j && sum <= n; sum += fac[--j]);
		if (sum == n) printf("%lu\n", n);
	}

	return 0;
}
