#include <stdio.h>
#include <stdlib.h>

inline
int randn(int m)
{
	int rand_max = RAND_MAX - (RAND_MAX % m);
	int r;
	while ((r = rand()) > rand_max);
	return r / (rand_max / m);
}

int main()
{
	int i, x, y, r2;
	unsigned long buf[31] = {0}; /* could just use 2d array */

	for (i = 0; i < 100; ) {
		x = randn(31) - 15;
		y = randn(31) - 15;
		r2 = x * x + y * y;
		if (r2 >= 100 && r2 <= 225) {
			buf[15 + y] |= 1 << (x + 15);
			i++;
		}
	}

	for (y = 0; y < 31; y++) {
		for (x = 0; x < 31; x++)
			printf((buf[y] & 1 << x) ? ". " : "  ");
		printf("\n");
	}

	return 0;
}
