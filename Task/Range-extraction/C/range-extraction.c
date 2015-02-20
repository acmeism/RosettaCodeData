#include <stdio.h>
#include <stdlib.h>

size_t rprint(char *s, int *x, int len)
{
#define sep (a > s ? "," : "") /* use comma except before first output */
#define ol (s ? 100 : 0)       /* print only if not testing for length */
	int i, j;
	char *a = s;
	for (i = j = 0; i < len; i = ++j) {
		for (; j < len - 1 && x[j + 1] == x[j] + 1; j++);

		if (i + 1 < j)
			a += snprintf(s?a:s, ol, "%s%d-%d", sep, x[i], x[j]);
		else
			while (i <= j)
				a += snprintf(s?a:s, ol, "%s%d", sep, x[i++]);
	}
	return a - s;
#undef sep
#undef ol
}

int main()
{
	int x[] = {	0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
			15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
			25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
			37, 38, 39 };

	char *s = malloc(rprint(0, x, sizeof(x) / sizeof(int)) + 1);
	rprint(s, x, sizeof(x) / sizeof(int));
	printf("%s\n", s);

	return 0;
}
