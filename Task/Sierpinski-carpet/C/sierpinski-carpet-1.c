#include <stdio.h>

int main()
{
	int i, j, dim, d;
	int depth = 3;

	for (i = 0, dim = 1; i < depth; i++, dim *= 3);

	for (i = 0; i < dim; i++) {
		for (j = 0; j < dim; j++) {
			for (d = dim / 3; d; d /= 3)
				if ((i % (d * 3)) / d == 1 && (j % (d * 3)) / d == 1)
					break;
			printf(d ? "  " : "##");
		}
		printf("\n");
	}

	return 0;
}
