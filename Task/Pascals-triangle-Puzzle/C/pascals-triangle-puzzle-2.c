#include <stdio.h>
#include <stdlib.h>

void show(int *x) {
	int i, j;

	for (i = 0; i < 5; i++)
		for (j = 0; j <= i; j++)
			printf("%4d%c", *(x++), j < i ? ' ' : '\n');
}

inline int sign(int i)
{
	return i < 0 ? -1 : i > 0;
}

int iter(int *v, int *diff) {
	int sum, i, j, e = 0;

#	define E(x, row, col) x[(row) * ((row) + 1) / 2 + (col)]
	/* enforce boundary conditions */
	E(v, 0, 0) = 151;
	E(v, 2, 0) = 40;
	E(v, 4, 1) = 11;
	E(v, 4, 3) = 4;

	/* calculate difference from equilibrium */
	for (i = 1; i < 5; i++) {
		for (j = 0; j <= i; j++) {
			E(diff, i, j) = 0;
			if (j < i)
				E(diff, i, j) += E(v, i - 1, j) -
						 E(v, i, j + 1) -
						 E(v, i, j);
			if (j)
				E(diff, i, j) += E(v, i - 1, j - 1) -
						 E(v, i, j - 1) -
						 E(v, i, j);
		}
	}

	for (i = 0; i < 4; i++)
		for (j = 0; j < i; j++)
			E(diff, i, j) += E(v, i + 1, j) +
					 E(v, i + 1, j + 1) -
					 E(v, i, j);

	E(diff, 4, 2) += E(v, 4, 0) + E(v, 4, 4) - E(v, 4, 2);
#	undef E

	/* Do feedback, check if we are done. */
	for (i = sum = 0; i < 15; i++) {
		sum += !!sign(e = diff[i]);

		/* 1/5-ish feedback strength on average.  These numbers are highly
		   magical, depending on nodes' connectivities. */
		if (e >= 4 || e <= -4) 		v[i] += e/5;
		else if (rand() < RAND_MAX/4)	v[i] += sign(e);
	}
	return sum;
}

int main() {
	int v[15] = { 0 }, diff[15] = { 0 }, i, s;

	for (i = s = 1; s; i++) {
		s = iter(v, diff);
		printf("pass %d: %d\n", i, s);
	}
	show(v);

	return 0;
}
