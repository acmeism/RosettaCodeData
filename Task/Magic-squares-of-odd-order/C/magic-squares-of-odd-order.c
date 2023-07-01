#include <stdio.h>
#include <stdlib.h>

int f(int n, int x, int y)
{
	return (x + y*2 + 1)%n;
}

int main(int argc, char **argv)
{
	int i, j, n;

	//Edit: Add argument checking
	if(argc!=2) return 1;

	//Edit: Input must be odd and not less than 3.
	n = atoi(argv[1]);
	if (n < 3 || (n%2) == 0) return 2;

	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++)
			printf("% 4d", f(n, n - j - 1, i)*n + f(n, j, i) + 1);
		putchar('\n');
	}
	printf("\n Magic Constant: %d.\n", (n*n+1)/2*n);

	return 0;
}
