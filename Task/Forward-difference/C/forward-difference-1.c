#include <stdlib.h>
#include <string.h>
#include <stdio.h>

double* fwd_diff(double* x, unsigned int len, unsigned int order)
{
	unsigned int i, j;
	double* y;

	/* handle two special cases */
	if (order >= len) return 0;

	y = malloc(sizeof(double) * len);
	if (!order) {
		memcpy(y, x, sizeof(double) * len);
		return y;
	}

	/* first order diff goes from x->y, later ones go from y->y */
	for (j = 0; j < order; j++, x = y)
		for (i = 0, len--; i < len; i++)
			y[i] = x[i + 1] - x[i];

	y = realloc(y, sizeof(double) * len);
	return y;
}

int main(void)
{
	double *y, x[] = {90, 47, 58, 29, 22, 32, 55, 5, 55, 73};
	int i, len = sizeof(x) / sizeof(x[0]);

	y = fwd_diff(x, len, 1);
	for (i = 0; i < len - 1; i++)
		printf("%g ", y[i]);
	putchar('\n');

	return 0;
}
