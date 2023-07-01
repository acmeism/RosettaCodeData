#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_PRIME 1000000
char *primes;
int n_primes;

/*  Sieve. If we were to handle 10^9 range, use bit field. Regardless,
 *  if a large amount of prime numbers need to be tested, sieve is fast.
 */
void init_primes()
{
	int j;
	primes = malloc(sizeof(char) * MAX_PRIME);
	memset(primes, 1, MAX_PRIME);
	primes[0] = primes[1] = 0;
	int i = 2;
	while (i * i < MAX_PRIME) {
		for (j = i * 2; j < MAX_PRIME; j += i)
			primes[j] = 0;
		while (++i < MAX_PRIME && !primes[i]);
	}
}

int left_trunc(int n)
{
	int tens = 1;
	while (tens < n) tens *= 10;

	while (n) {
		if (!primes[n]) return 0;
		tens /= 10;
		if (n < tens) return 0;
		n %= tens;
	}
	return 1;
}

int right_trunc(int n)
{
	while (n) {
		if (!primes[n]) return 0;
		n /= 10;
	}
	return 1;
}

int main()
{
	int n;
	int max_left = 0, max_right = 0;
	init_primes();

	for (n = MAX_PRIME - 1; !max_left;  n -= 2)
		if (left_trunc(n)) max_left = n;

	for (n = MAX_PRIME - 1; !max_right; n -= 2)
		if (right_trunc(n)) max_right = n;

	printf("Left: %d; right: %d\n", max_left, max_right);
	return 0;
}
