#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

/* f : number to convert.
 * num, denom: returned parts of the rational.
 * md: max denominator value.  Note that machine floating point number
 *     has a finite resolution (10e-16 ish for 64 bit double), so specifying
 *     a "best match with minimal error" is often wrong, because one can
 *     always just retrieve the significand and return that divided by
 *     2**52, which is in a sense accurate, but generally not very useful:
 *     1.0/7.0 would be "2573485501354569/18014398509481984", for example.
 */
void rat_approx(double f, int64_t md, int64_t *num, int64_t *denom)
{
	/*  a: continued fraction coefficients. */
	int64_t a, h[3] = { 0, 1, 0 }, k[3] = { 1, 0, 0 };
	int64_t x, d, n = 1;
	int i, neg = 0;

	if (md <= 1) { *denom = 1; *num = (int64_t) f; return; }

	if (f < 0) { neg = 1; f = -f; }

	while (f != floor(f)) { n <<= 1; f *= 2; }
	d = f;

	/* continued fraction and check denominator each step */
	for (i = 0; i < 64; i++) {
		a = n ? d / n : 0;
		if (i && !a) break;

		x = d; d = n; n = x % n;

		x = a;
		if (k[1] * a + k[0] >= md) {
			x = (md - k[0]) / k[1];
			if (x * 2 >= a || k[1] >= md)
				i = 65;
			else
				break;
		}

		h[2] = x * h[1] + h[0]; h[0] = h[1]; h[1] = h[2];
		k[2] = x * k[1] + k[0]; k[0] = k[1]; k[1] = k[2];
	}
	*denom = k[1];
	*num = neg ? -h[1] : h[1];
}

int main()
{
	int i;
	int64_t d, n;
	double f;

	printf("f = %16.14f\n", f = 1.0/7);
	for (i = 1; i <= 20000000; i *= 16) {
		printf("denom <= %d: ", i);
		rat_approx(f, i, &n, &d);
		printf("%lld/%lld\n", n, d);
	}

	printf("\nf = %16.14f\n", f = atan2(1,1) * 4);
	for (i = 1; i <= 20000000; i *= 16) {
		printf("denom <= %d: ", i);
		rat_approx(f, i, &n, &d);
		printf("%lld/%lld\n", n, d);
	}

	return 0;
}
