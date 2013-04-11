#include <stdio.h>

#define N 10000000
#define CS N	/* cache size */

typedef unsigned long ulong;
ulong cache[CS] = {0};

ulong hailstone(ulong n)
{
	int x;
	if (n == 1) return 1;
	if (n < CS && cache[n]) return cache[n];

	x = 1 + hailstone((n & 1) ? 3 * n + 1 : n / 2);
	if (n < CS) cache[n] = x;
	return x;
}

int main()
{
	int i, l, max = 0, mi;
	for (i = 1; i < N; i++) {
		if ((l = hailstone(i)) > max) {
			max = l;
			mi = i;
		}
	}
	printf("max below %d: %d, length %d\n", N, mi, max);
	return 0;
}
