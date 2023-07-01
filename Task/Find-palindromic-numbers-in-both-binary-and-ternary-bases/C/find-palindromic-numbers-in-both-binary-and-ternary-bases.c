#include <stdio.h>
typedef unsigned long long xint;

int is_palin2(xint n)
{
	xint x = 0;
	if (!(n&1)) return !n;
	while (x < n) x = x<<1 | (n&1), n >>= 1;
	return n == x || n == x>>1;
}

xint reverse3(xint n)
{
	xint x = 0;
	while (n) x = x*3 + (n%3), n /= 3;
	return x;
}

void print(xint n, xint base)
{
	putchar(' ');
	// printing digits backwards, but hey, it's a palindrome
	do { putchar('0' + (n%base)), n /= base; } while(n);
	printf("(%lld)", base);
}

void show(xint n)
{
	printf("%llu", n);
	print(n, 2);
	print(n, 3);
	putchar('\n');
}

xint min(xint a, xint b) { return a < b ? a : b; }
xint max(xint a, xint b) { return a > b ? a : b; }

int main(void)
{
	xint lo, hi, lo2, hi2, lo3, hi3, pow2, pow3, i, n;
	int cnt;

	show(0);
	cnt = 1;

	lo = 0;
	hi = pow2 = pow3 = 1;

	while (1) {
		for (i = lo; i < hi; i++) {
			n = (i * 3 + 1) * pow3 + reverse3(i);
			if (!is_palin2(n)) continue;
			show(n);
			if (++cnt >= 7) return 0;
		}

		if (i == pow3)
			pow3 *= 3;
		else
			pow2 *= 4;

		while (1) {
			while (pow2 <= pow3) pow2 *= 4;

			lo2 = (pow2 / pow3 - 1) / 3;
			hi2 = (pow2 * 2 / pow3 - 1) / 3 + 1;
			lo3 = pow3 / 3;
			hi3 = pow3;

			if (lo2 >= hi3)
				pow3 *= 3;
			else if (lo3 >= hi2)
				pow2 *= 4;
			else {
				lo = max(lo2, lo3);
				hi = min(hi2, hi3);
				break;
			}
		}
	}
	return 0;
}
