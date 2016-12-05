#include <stdio.h>

int main(void)
{
	int i, j, n = 12;

	for (j = 1; j <= n; j++) printf("%3d%c", j, j != n ? ' ' : '\n');
	for (j = 0; j <= n; j++) printf(j != n ? "----" : "+\n");

	for (i = 1; i <= n; i++) {
		for (j = 1; j <= n; j++)
			printf(j < i ? "    " : "%3d ", i * j);
                printf("| %d\n", i);
        }

	return 0;
}
