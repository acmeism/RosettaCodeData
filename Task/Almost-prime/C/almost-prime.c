#include <stdio.h>

int kprime(int n, int k)
{
	int p, f = 0;
	for (p = 2; f < k && p*p <= n; p++)
		while (0 == n % p)
			n /= p, f++;

	return f + (n > 1) == k;
}

int main(void)
{
	int i, c, k;

	for (k = 1; k <= 5; k++) {
		printf("k = %d:", k);

		for (i = 2, c = 0; c < 10; i++)
			if (kprime(i, k)) {
				printf(" %d", i);
				c++;
			}

		putchar('\n');
	}

	return 0;
}
