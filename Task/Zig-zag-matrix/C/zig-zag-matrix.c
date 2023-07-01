#include <stdio.h>
#include <stdlib.h>

int main(int c, char **v)
{
	int i, j, m, n, *s;

	/* default size: 5 */
	if (c < 2 || ((m = atoi(v[1]))) <= 0) m = 5;

	/* alloc array*/
	s = malloc(sizeof(int) * m * m);

	for (i = n = 0; i < m * 2; i++)
		for (j = (i < m) ? 0 : i-m+1; j <= i && j < m; j++)
			s[(i&1)? j*(m-1)+i : (i-j)*m+j ] = n++;

	for (i = 0; i < m * m; putchar((++i % m) ? ' ':'\n'))
		printf("%3d", s[i]);

	/* free(s) */
	return 0;
}
