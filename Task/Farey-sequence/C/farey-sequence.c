#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void farey(int n)
{
	typedef struct { int d, n; } frac;
	frac f1 = {0, 1}, f2 = {1, n}, t;
	int k;

	printf("%d/%d %d/%d", 0, 1, 1, n);
	while (f2.n > 1) {
		k = (n + f1.n) / f2.n;
		t = f1, f1 = f2, f2 = (frac) { f2.d * k - t.d, f2.n * k - t.n };
		printf(" %d/%d", f2.d, f2.n);
	}

	putchar('\n');
}

typedef unsigned long long ull;
ull *cache;
size_t ccap;

ull farey_len(int n)
{
	if (n >= ccap) {
		size_t old = ccap;
		if (!ccap) ccap = 16;
		while (ccap <= n) ccap *= 2;
		cache = realloc(cache, sizeof(ull) * ccap);
		memset(cache + old, 0, sizeof(ull) * (ccap - old));
	} else if (cache[n])
		return cache[n];

	ull len = (ull)n*(n + 3) / 2;
	int p, q = 0;
	for (p = 2; p <= n; p = q) {
		q = n/(n/p) + 1;
		len -= farey_len(n/p) * (q - p);
	}

	cache[n] = len;
	return len;
}

int main(void)
{
	int n;
	for (n = 1; n <= 11; n++) {
		printf("%d: ", n);
		farey(n);
	}

	for (n = 100; n <= 1000; n += 100)
		printf("%d: %llu items\n", n, farey_len(n));

	n = 10000000;
	printf("\n%d: %llu items\n", n, farey_len(n));
	return 0;
}
