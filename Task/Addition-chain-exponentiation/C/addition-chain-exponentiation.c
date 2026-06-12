#include <stdio.h>

#include "achain.c" /* not common practice */

/* don't have a C99 compiler atm */
typedef struct {double u, v;} cplx;

inline cplx c_mul(cplx a, cplx b)
{
	cplx c;
	c.u = a.u * b.u - a.v * b.v;
	c.v = a.u * b.v + a.v * b.u;
	return c;
}

cplx chain_expo(cplx x, int n)
{
	int i, j, k, l, e[32];
	cplx v[32];

	l = seq(n, 0, e);

	puts("Exponents:");
	for (i = 0; i <= l; i++)
		printf("%d%c", e[i], i == l ? '\n' : ' ');

	v[0] = x; v[1] = c_mul(x, x);
	for (i = 2; i <= l; i++) {
		for (j = i - 1; j; j--) {
			for (k = j; k >= 0; k--) {
				if (e[k] + e[j] < e[i]) break;
				if (e[k] + e[j] > e[i]) continue;
				v[i] = c_mul(v[j], v[k]);
				j = 1;
				break;
			}
		}
	}
	printf("(%f + i%f)^%d = %f + i%f\n",
		x.u, x.v, n, v[l].u, v[l].v);

	return x;
}

int bin_len(int n)
{
	int r, o;
	for (r = o = -1; n; n >>= 1, r++)
		if (n & 1) o++;
	return r + o;
}

int main()
{
	cplx	r1 = {1.0000254989, 0.0000577896},
		r2 = {1.0000220632, 0.0000500026};
	int n1 = 27182, n2 = 31415, i;

	init();
	puts("Precompute chain lengths");
	seq_len(n2);

	chain_expo(r1, n1);
	chain_expo(r2, n2);
	puts("\nchain lengths: shortest binary");
	printf("%14d %7d %7d\n", n1, seq_len(n1), bin_len(n1));
	printf("%14d %7d %7d\n", n2, seq_len(n2), bin_len(n2));
	for (i = 1; i < 100; i++)
		printf("%14d %7d %7d\n", i, seq_len(i), bin_len(i));
	return 0;
}
