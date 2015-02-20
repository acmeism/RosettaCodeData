#include <stdio.h>

int semiprime(int n)
{
	int p, f = 0;
	for (p = 2; f < 2 && p*p <= n; p++)
		while (0 == n % p)
			n /= p, f++;

	return f + (n > 1) == 2;
}

int main(void)
{
	int i;
	for (i = 2; i < 100; i++)
		if (semiprime(i)) printf(" %d", i);
	putchar('\n');

	return 0;
}
