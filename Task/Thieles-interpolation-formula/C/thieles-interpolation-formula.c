#include <stdio.h>
#include <string.h>
#include <math.h>

#define N 32
#define N2 (N * (N - 1) / 2)
#define STEP .05

double xval[N], t_sin[N], t_cos[N], t_tan[N];

/* rho tables, layout:
	rho_{n-1}(x0)
	rho_{n-2}(x0), rho_{n-1}(x1),
	....
	rho_0(x0), rho_0(x1), ... rho_0(x_{n-1})
   rho_i row starts at index (n - 1 - i) * (n - i) / 2  	*/
double r_sin[N2], r_cos[N2], r_tan[N2];

/* both rho and thiele functions recursively resolve values as decribed by
   formulas.  rho is cached, thiele is not. */

/* rho_n(x_i, x_{i+1}, ..., x_{i + n}) */
double rho(double *x, double *y, double *r, int i, int n)
{
	if (n < 0) return 0;
	if (!n) return y[i];

	int idx = (N - 1 - n) * (N - n) / 2 + i;
	if (r[idx] != r[idx]) /* only happens if value not computed yet */
		r[idx] = (x[i] - x[i + n])
			/ (rho(x, y, r, i, n - 1) - rho(x, y, r, i + 1, n - 1))
			+ rho(x, y, r, i + 1, n - 2);
	return r[idx];
}

double thiele(double *x, double *y, double *r, double xin, int n)
{
	if (n > N - 1) return 1;
	return rho(x, y, r, 0, n) - rho(x, y, r, 0, n - 2)
		+ (xin - x[n]) / thiele(x, y, r, xin, n + 1);
}

#define i_sin(x) thiele(t_sin, xval, r_sin, x, 0)
#define i_cos(x) thiele(t_cos, xval, r_cos, x, 0)
#define i_tan(x) thiele(t_tan, xval, r_tan, x, 0)

int main()
{
	int i;
	for (i = 0; i < N; i++) {
		xval[i] = i * STEP;
		t_sin[i] = sin(xval[i]);
		t_cos[i] = cos(xval[i]);
		t_tan[i] = t_sin[i] / t_cos[i];
	}
	for (i = 0; i < N2; i++)
		/* init rho tables to NaN */
		r_sin[i] = r_cos[i] = r_tan[i] = 0/0.;

	printf("%16.14f\n", 6 * i_sin(.5));
	printf("%16.14f\n", 3 * i_cos(.5));
	printf("%16.14f\n", 4 * i_tan(1.));
	return 0;
}
