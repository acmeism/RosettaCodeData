#include <stdio.h>
#include <stdlib.h>
#include <complex.h>
#include <math.h>

typedef double complex cplx;

void quad_root
(double a, double b, double c, cplx * ra, cplx *rb)
{
	double d, e;
	if (!a) {
		*ra = b ? -c / b : 0;
		*rb = 0;
		return;
	}
	if (!c) {
		*ra = 0;
		*rb = -b / a;
		return;
	}

	b /= 2;
	if (fabs(b) > fabs(c)) {
		e = 1 - (a / b) * (c / b);
		d = sqrt(fabs(e)) * fabs(b);
	} else {
		e = (c > 0) ? a : -a;
		e = b * (b / fabs(c)) - e;
		d = sqrt(fabs(e)) * sqrt(fabs(c));
	}

	if (e < 0) {
		e = fabs(d / a);
		d = -b / a;
		*ra = d + I * e;
		*rb = d - I * e;
		return;
	}

	d = (b >= 0) ? d : -d;
	e = (d - b) / a;
	d = e ? (c / e) / a : 0;
	*ra = d;
	*rb = e;
	return;
}

int main()
{
	cplx ra, rb;
	quad_root(1, 1e12 + 1, 1e12, &ra, &rb);
	printf("(%g + %g i), (%g + %g i)\n",
		creal(ra), cimag(ra), creal(rb), cimag(rb));

	quad_root(1e300, -1e307 + 1, 1e300, &ra, &rb);
	printf("(%g + %g i), (%g + %g i)\n",
		creal(ra), cimag(ra), creal(rb), cimag(rb));

	return 0;
}
