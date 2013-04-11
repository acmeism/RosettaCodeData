#include <stdio.h>
#include <stdlib.h>

typedef unsigned long long xint;
typedef unsigned long ulong;

inline ulong gcd(ulong m, ulong n)
{
	ulong t;
	while (n) { t = n; n = m % n; m = t; }
	return m;
}

int main()
{
	ulong a, b, c, pytha = 0, prim = 0, max_p = 100;
	xint aa, bb, cc;

	for (a = 1; a <= max_p / 3; a++) {
		aa = (xint)a * a;
		printf("a = %lu\r", a); /* show that we are working */
		fflush(stdout);

		/*  max_p/2: valid limit, because one side of triangle
		 *  must be less than the sum of the other two
		 */
		for (b = a + 1; b < max_p/2; b++) {
			bb = (xint)b * b;
			for (c = b + 1; c < max_p/2; c++) {
				cc = (xint)c * c;
				if (aa + bb < cc) break;
				if (a + b + c > max_p) break;

				if (aa + bb == cc) {
					pytha++;
					if (gcd(a, b) == 1) prim++;
				}
			}
		}
	}

	printf("Up to %lu, there are %lu triples, of which %lu are primitive\n",
		max_p, pytha, prim);

	return 0;
}
