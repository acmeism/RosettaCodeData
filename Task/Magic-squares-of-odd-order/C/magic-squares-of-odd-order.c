#include <stdio.h>
#include <stdlib.h>

int f(int n, int x, int y)
{
	return (x + y*2 + 1)%n;
}

int main(int argc, char **argv)
{
	int i, j, n = atoi(argv[1]);
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++)
			printf("% 4d", f(n, n - j - 1, i)*n + f(n, j, i) + 1);
		putchar('\n');
	}

	return 0;
}
