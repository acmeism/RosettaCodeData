#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double rk4(double(*f)(double, double), double dx, double x, double y)
{
	double	k1 = dx * f(x, y),
		k2 = dx * f(x + dx / 2, y + k1 / 2),
		k3 = dx * f(x + dx / 2, y + k2 / 2),
		k4 = dx * f(x + dx, y + k3);
	return y + (k1 + 2 * k2 + 2 * k3 + k4) / 6;
}

double rate(double x, double y)
{
	return x * sqrt(y);
}

int main(void)
{
	double *y, x, y2;
	double x0 = 0, x1 = 10, dx = .1;
	int i, n = 1 + (x1 - x0)/dx;
	y = malloc(sizeof(double) * n);

	for (y[0] = 1, i = 1; i < n; i++)
		y[i] = rk4(rate, dx, x0 + dx * (i - 1), y[i-1]);

	printf("x\ty\trel. err.\n------------\n");
	for (i = 0; i < n; i += 10) {
		x = x0 + dx * i;
		y2 = pow(x * x / 4 + 1, 2);
		printf("%g\t%g\t%g\n", x, y[i], y[i]/y2 - 1);
	}

	return 0;
}
