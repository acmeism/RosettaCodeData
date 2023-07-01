#include <assert.h>
#include <stdio.h>

int main(int c, char **v)
{
	unsigned int n = 1 << (c - 1), i = n, j, k;
	assert(n);

	while (i--) {
		if (!(i & (i + (i & -(int)i)))) // consecutive 1s
			continue;

		for (j = n, k = 1; j >>= 1; k++)
			if (i & j) printf("%s ", v[k]);

		putchar('\n');
	}

	return 0;
}
