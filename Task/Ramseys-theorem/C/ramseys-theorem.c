#include <stdio.h>

int a[17][17], idx[4];

int find_group(int type, int min_n, int max_n, int depth)
{
	int i, n;
	if (depth == 4) {
		printf("totally %sconnected group:", type ? "" : "un");
		for (i = 0; i < 4; i++) printf(" %d", idx[i]);
		putchar('\n');
		return 1;
	}

	for (i = min_n; i < max_n; i++) {
		for (n = 0; n < depth; n++)
			if (a[idx[n]][i] != type) break;

		if (n == depth) {
			idx[n] = i;
			if (find_group(type, 1, max_n, depth + 1))
				return 1;
		}
	}
	return 0;
}

int main()
{
	int i, j, k;
	const char *mark = "01-";

	for (i = 0; i < 17; i++)
		a[i][i] = 2;

	for (k = 1; k <= 8; k <<= 1) {
		for (i = 0; i < 17; i++) {
			j = (i + k) % 17;
			a[i][j] = a[j][i] = 1;
		}
	}

	for (i = 0; i < 17; i++) {
		for (j = 0; j < 17; j++)
			printf("%c ", mark[a[i][j]]);
		putchar('\n');
	}

	// testcase breakage
	// a[2][1] = a[1][2] = 0;

	// it's symmetric, so only need to test groups containing node 0
	for (i = 0; i < 17; i++) {
		idx[0] = i;
		if (find_group(1, i+1, 17, 1) || find_group(0, i+1, 17, 1)) {
			puts("no good");
			return 0;
		}
	}
	puts("all good");
	return 0;
}
