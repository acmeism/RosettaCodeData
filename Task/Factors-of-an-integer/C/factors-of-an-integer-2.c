#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* 65536 = 2^16, so we can factor all 32 bit ints */
char bits[65536];

typedef unsigned long ulong;
ulong primes[7000], n_primes;

typedef struct { ulong p, e; } prime_factor; /* prime, exponent */

void sieve()
{
	int i, j;
	memset(bits, 1, 65536);
	bits[0] = bits[1] = 0;
	for (i = 0; i < 256; i++)
		if (bits[i])
			for (j = i * i; j < 65536; j += i)
				bits[j] = 0;

	/* collect primes into a list. slightly faster this way if dealing with large numbers */
	for (i = j = 0; i < 65536; i++)
		if (bits[i]) primes[j++] = i;

	n_primes = j;
}

int get_prime_factors(ulong n, prime_factor *lst)
{
	ulong i, e, p;
	int len = 0;

	for (i = 0; i < n_primes; i++) {
		p = primes[i];
		if (p * p > n) break;
		for (e = 0; !(n % p); n /= p, e++);
		if (e) {
			lst[len].p = p;
			lst[len++].e = e;
		}
	}

	return n == 1 ? len : (lst[len].p = n, lst[len].e = 1, ++len);
}

int ulong_cmp(const void *a, const void *b)
{
	return *(ulong*)a < *(ulong*)b ? -1 : *(ulong*)a > *(ulong*)b;
}

int get_factors(ulong n, ulong *lst)
{
	int n_f, len, len2, i, j, k, p;
	prime_factor f[100];

	n_f = get_prime_factors(n, f);

	len2 = len = lst[0] = 1;
	/* L = (1); L = (L, L * p**(1 .. e)) forall((p, e)) */
	for (i = 0; i < n_f; i++, len2 = len)
		for (j = 0, p = f[i].p; j < f[i].e; j++, p *= f[i].p)
			for (k = 0; k < len2; k++)
				lst[len++] = lst[k] * p;

	qsort(lst, len, sizeof(ulong), ulong_cmp);
	return len;
}

int main()
{
	ulong fac[10000];
	int len, i, j;
	ulong nums[] = {3, 120, 1024, 2UL*2*2*2*3*3*3*5*5*7*11*13*17*19 };

	sieve();

	for (i = 0; i < 4; i++) {
		len = get_factors(nums[i], fac);
		printf("%lu:", nums[i]);
		for (j = 0; j < len; j++)
			printf(" %lu", fac[j]);
		printf("\n");
	}

	return 0;
}
