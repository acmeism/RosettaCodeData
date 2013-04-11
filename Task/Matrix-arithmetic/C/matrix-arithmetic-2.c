#include <stdio.h>
#include <stdlib.h>
#include <tgmath.h>

void showmat(const char *s, double **m, int n)
{
	printf("%s:\n", s);
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++)
			printf("%12.4f", m[i][j]);
			putchar('\n');
	}
}

int trianglize(double **m, int n)
{
	int sign = 1;
	for (int i = 0; i < n; i++) {
		int max = 0;

		for (int row = i; row < n; row++)
			if (fabs(m[row][i]) > fabs(m[max][i]))
				max = row;

		if (max) {
			sign = -sign;
			double *tmp = m[i];
			m[i] = m[max], m[max] = tmp;
		}

		if (!m[i][i]) return 0;

		for (int row = i + 1; row < n; row++) {
			double r = m[row][i] / m[i][i];
			if (!r)	continue;

			for (int col = i; col < n; col ++)
				m[row][col] -= m[i][col] * r;
		}
	}
	return sign;
}

double det(double *in, int n)
{
	double *m[n];
	m[0] = in;

	for (int i = 1; i < n; i++)
		m[i] = m[i - 1] + n;

	showmat("Matrix", m, n);

	int sign = trianglize(m, n);
	if (!sign)
		return 0;

	showmat("Upper triangle", m, n);

	double p = 1;
	for (int i = 0; i < n; i++)
		p *= m[i][i];
	return p * sign;
}

#define N 18
int main(void)
{
	double x[N * N];
	srand(0);
	for (int i = 0; i < N * N; i++)
		x[i] = rand() % N;

	printf("det: %19f\n", det(x, N));
	return 0;
}
