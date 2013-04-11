#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int inc(int x) { return (int)&((char *)x)[1]; }
int dec(int x) { return (int)&((char *)x)[-1]; }
int gt(int x, int y)
{
	while (y && x) y = dec(y), x = dec(x);
	return x;
}

int eq(int x, int y)
{
	return !gt(x, y) && !gt(y, x);
}

int add(int x, int y)
{
	while(y) x = inc(x), y = dec(y);
	return x;
}

/* strlen(a) + 1 */
int length(const char *a)
{
	char *x = 0; // assuming (int)(char*)0 == 0
	if (!a) return 0;
	while (*a) a++, x++;
	return (int)x;
}

char *str_cat(char *a, const char *b)
{
	int len = add(1, add(length(a), length(b)));
	if (!(a = realloc(a, len))) abort();
	return strcat(a, b);
}

char *get_line(char *l, FILE *fp)
{
	int c, len = 0;
	char tmp[2] = {0};

	*l = 0;
	while ((c = fgetc(fp)) != EOF) {
		*tmp = c;
		len = inc(len);

		l = str_cat(l, tmp);
		if (eq(*tmp, '\n')) return l;
	}

	*tmp = '\n';
	return len ? str_cat(l, tmp) : l;
}

int main()
{
	int l1, l2;
	char *line = malloc(1), *buf = malloc(1), *longest = malloc(1);
	while (1) {
		line = get_line(line, stdin);

		if (!(l1 = length(line))) break;
		l2 = length(longest);

		if (gt(l1, l2)) {
			*buf = *longest = 0;
			longest = str_cat(longest, line);
		} else if (gt(l2, l1)) continue;

		buf = str_cat(buf, line);
	}
	printf("%s", buf);

	free(buf);
	free(longest);
	free(line);

	return 0;
}
