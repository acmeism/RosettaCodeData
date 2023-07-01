#include <stdio.h>

typedef unsigned long long ull;

ull binomial(ull m, ull n)
{
	ull r = 1, d = m - n;
	if (d > n) { n = d; d = m - n; }

	while (m > n) {
		r *= m--;
		while (d > 1 && ! (r%d) ) r /= d--;
	}

	return r;
}

ull catalan1(int n) {
	return binomial(2 * n, n) / (1 + n);
}

ull catalan2(int n) {
	int i;
	ull r = !n;

	for (i = 0; i < n; i++)
		r += catalan2(i) * catalan2(n - 1 - i);
	return r;
}

ull catalan3(int n)
{
	return n ? 2 * (2 * n - 1) * catalan3(n - 1) / (1 + n) : 1;
}

int main(void)
{
	int i;
	puts("\tdirect\tsumming\tfrac");
	for (i = 0; i < 16; i++) {
		printf("%d\t%llu\t%llu\t%llu\n", i,
			catalan1(i), catalan2(i), catalan3(i));
	}

	return 0;
}
