/*----------------------------------------------------------------------
gjinv - Invert a matrix, Gauss-Jordan algorithm
A is destroyed.  Returns 1 for a singular matrix.

___Name_____Type______In/Out____Description_____________________________
   a[n*n]   double*   In        An N by N matrix
   n        int       In        Order of matrix
   b[n*n]   double*   Out       Inverse of A
----------------------------------------------------------------------*/
#include <math.h>
int gjinv (double *a, int n, double *b)
{
	int i, j, k, p;
	double f, g, tol;
	if (n < 1) return -1;  /* Function Body */
	f = 0.;  /* Frobenius norm of a */
	for (i = 0; i < n; ++i) {
		for (j = 0; j < n; ++j) {
			g = a[j+i*n];
			f += g * g;
		}
	}
	f = sqrt(f);
	tol = f * 2.2204460492503131e-016;
	for (i = 0; i < n; ++i) {  /* Set b to identity matrix. */
		for (j = 0; j < n; ++j) {
			b[j+i*n] = (i == j) ? 1. : 0.;
		}
	}
	for (k = 0; k < n; ++k) {  /* Main loop */
		f = fabs(a[k+k*n]);  /* Find pivot. */
		p = k;
		for (i = k+1; i < n; ++i) {
			g = fabs(a[k+i*n]);
			if (g > f) {
				f = g;
				p = i;
			}
		}
		if (f < tol) return 1;  /* Matrix is singular. */
		if (p != k) {  /* Swap rows. */
			for (j = k; j < n; ++j) {
				f = a[j+k*n];
				a[j+k*n] = a[j+p*n];
				a[j+p*n] = f;
			}
			for (j = 0; j < n; ++j) {
				f = b[j+k*n];
				b[j+k*n] = b[j+p*n];
				b[j+p*n] = f;
			}
		}
		f = 1. / a[k+k*n];  /* Scale row so pivot is 1. */
		for (j = k; j < n; ++j) a[j+k*n] *= f;
		for (j = 0; j < n; ++j) b[j+k*n] *= f;
		for (i = 0; i < n; ++i) {  /* Subtract to get zeros. */
			if (i == k) continue;
			f = a[k+i*n];
			for (j = k; j < n; ++j) a[j+i*n] -= a[j+k*n] * f;
			for (j = 0; j < n; ++j) b[j+i*n] -= b[j+k*n] * f;
		}
	}
	return 0;
} /* end of gjinv */
