#include <stdio.h>
#include <stdlib.h>

int spiral(int w, int h, int x, int y)
{
	return y ? w + spiral(h - 1, w, y - 1, w - x - 1) : x;
}

int main(int argc, char **argv)
{
	int w = atoi(argv[1]), h = atoi(argv[2]), i, j;
	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++)
			printf("%4d", spiral(w, h, j, i));
		putchar('\n');
	}
	return 0;
}
