#include <stdio.h>
#include <string.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

double test_func(double x)
{
	//return sin(cos(x)) * exp(-(x - 5)*(x - 5)/10);
	return cos(x);
}

// map x from range [min, max] to [min_to, max_to]
double map(double x, double min_x, double max_x, double min_to, double max_to)
{
	return (x - min_x)/(max_x - min_x)*(max_to - min_to) + min_to;
}

void cheb_coef(double (*func)(double), int n, double min, double max, double *coef)
{
	memset(coef, 0, sizeof(double) * n);
	for (int i = 0; i < n; i++) {
		double f = func(map(cos(M_PI*(i + .5f)/n), -1, 1, min, max))*2/n;
		for (int j = 0; j < n; j++)
			coef[j] += f*cos(M_PI*j*(i + .5f)/n);
	}
}

// f(x) = sum_{k=0}^{n - 1} c_k T_k(x) - c_0/2
// Note that n >= 2 is assumed; probably should check for that, however silly it is.
double cheb_approx(double x, int n, double min, double max, double *coef)
{
	double a = 1, b = map(x, min, max, -1, 1), c;
	double res = coef[0]/2 + coef[1]*b;

	x = 2*b;
	for (int i = 2; i < n; a = b, b = c, i++)
		// T_{n+1} = 2x T_n - T_{n-1}
		res += coef[i]*(c = x*b - a);

	return res;
}

int main(void)
{
#define N 10
	double c[N], min = 0, max = 1;
	cheb_coef(test_func, N, min, max, c);

	printf("Coefficients:");
	for (int i = 0; i < N; i++)
		printf(" %lg", c[i]);

	puts("\n\nApproximation:\n   x           func(x)     approx      diff");
	for (int i = 0; i <= 20; i++) {
		double x = map(i, 0, 20, min, max);
		double f = test_func(x);
		double approx = cheb_approx(x, N, min, max, c);

		printf("% 10.8lf % 10.8lf % 10.8lf % 4.1le\n",
			x, f, approx, approx - f);
	}

	return 0;
}
