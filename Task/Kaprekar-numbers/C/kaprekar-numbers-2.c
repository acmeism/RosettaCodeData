#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <limits.h>

typedef signed long long xint;

int factorize(xint n, xint* f)
{
	int i = 0;

	inline void get_factor(xint p) {
		if (n % p) return;
		for (f[i] = 1; !(n % p); f[i] *= p, n /= p);
		i++;
	}

	get_factor(2);
	get_factor(3);
	xint p, inc;
	for (p = 5, inc = 4; p * p <= n; p += (inc = 6 - inc))
		get_factor(p);
	if (n > 1) get_factor(n);
	return i;
}

// returns x where a x == 1 mod b
xint mul_inv(xint a, xint b)
{
	xint b0 = b, t, q;
	xint x0 = 0, x1 = 1;
	if (b == 1) return 1;
	while (a > 1) {
		q = a / b;
		t = b, b = a % b, a = t;
		t = x0, x0 = x1 - q * x0, x1 = t;
	}
	if (x1 < 0) x1 += b0;
	return x1;
}

int kaprekars(int base, xint top, xint *out, int max_cnt)
{
	xint f[64], pb;
	int len, cnt = 0;

	if (top >= LLONG_MAX / top) {
		fprintf(stderr, "too large: %lld\n", top);
		abort();
	}

	void kaps(xint a, int i) {
		if (i < len) {
			kaps(a * f[i], i + 1);
			kaps(a, i + 1);
			return;
		}

		xint x = a * mul_inv(a, (pb - 1) / a);
		if (x > 1 && x < top) {
			out[cnt++] = x;
			if (cnt >= max_cnt) {
				fprintf(stderr, "too many results\n");
				abort();
			}
		}
	}

	out[cnt++] = 1;

	for (pb = base; pb <= top * top / base; pb *= base) {
		len = factorize(pb - 1, f);
		if (f[len - 1] <= top) kaps(1, 0);
	}
	return cnt;
}

int main(void)
{
	xint x[1000];
	int len, b;
	
	for (b = 2; b < 99; b++) {
		printf("base %d:\n", b);

		// find all kaprekar numbers that won't overflow
		len = kaprekars(b, INT_MAX, x, 1000);
#if 0
		int i, j;
		xint t;
		for (i = 0; i < len; i++)
			for (j = 0; j < i; j++)
				if (x[i] < x[j])
					t = x[i], x[i] = x[j], x[j] = t;

		for (i = 0; i < len; i++)
			printf("%3d: %lld\n", i + 1, x[i]);
#else
		printf("\t%d kaprepar numbers\n", len);
#endif
	}

	return 0;
}
