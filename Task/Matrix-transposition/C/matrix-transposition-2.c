#include <stdio.h>

void transpose(double *m, int w, int h)
{
	int start, next, i;
	double tmp;

	for (start = 0; start <= w * h - 1; start++) {
		next = start;
		i = 0;
		do {	i++;
			next = (next % h) * w + next / h;
		} while (next > start);
		if (next < start || i == 1) continue;

		tmp = m[next = start];
		do {
			i = (next % h) * w + next / h;
			m[next] = (i == start) ? tmp : m[i];
			next = i;
		} while (next > start);
	}
}

void show_matrix(double *m, int w, int h)
{
	int i, j;
	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++)
			printf("%2g ", m[i * w + j]);
		putchar('\n');
	}
}

int main(void)
{
	int i;
	double m[15];
	for (i = 0; i < 15; i++) m[i] = i + 1;

	puts("before transpose:");
	show_matrix(m, 3, 5);

	transpose(m, 3, 5);

	puts("\nafter transpose:");
	show_matrix(m, 5, 3);

	return 0;
}
