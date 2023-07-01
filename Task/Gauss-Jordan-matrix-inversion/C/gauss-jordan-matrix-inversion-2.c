/* Test matrix inversion */
#include <stdio.h>
int main (void)
{
	static double aorig[16] = { -1.,-2.,3.,2.,-4.,
	    -1.,6.,2.,7.,-8.,9.,1.,1.,-2.,1.,3. };
	double a[16], b[16], c[16];
	int n = 4;
	int i, j, k, ierr;
	for (i = 0; i < n; ++i) {
		for (j = 0; j < n; ++j) {
			a[j+i*n] = aorig[j+i*n];
		}
	}
	ierr = gjinv (a, n, b);
	printf("gjinv returns #%i\n\n", ierr);
	printf("matrix:\n");
	for (i = 0; i < n; ++i) {
		for (j = 0; j < n; ++j) {
			printf("%8.3f", aorig[j+i*n]);
		}
		printf("\n");
	}
	printf("\ninverse:\n");
	for (i = 0; i < n; ++i) {
		for (j = 0; j < n; ++j) {
			printf("%8.3f", b[j+i*n]);
		}
		printf("\n");
	}
	for (j = 0; j < n; ++j) {
		for (k = 0; k < n; ++k) {
			c[k+j*n] = 0.;
			for (i = 0; i < n; ++i) {
				c[k+j*n] += aorig[i+j*n] * b[k+i*n];
			}
		}
	}
	printf("\nmatrix @ inverse:\n");
	for (i = 0; i < n; ++i) {
		for (j = 0; j < n; ++j) {
			printf("%8.3f", c[j+i*n]);
		}
		printf("\n");
	}
	ierr = gjinv (b, n, a);
	printf("\ngjinv returns #%i\n", ierr);
	printf("\ninverse of inverse:\n");
	for (i = 0; i < n; ++i) {
		for (j = 0; j < n; ++j) {
			printf("%8.3f", a[j+i*n]);
		}
		printf("\n");
	}
	return 0;
} /* end of test program */
