#include <stdio.h>
#include <string.h>

int cmp(const char *p, const char *q)
{
	while (*p && *q) p = &p[1], q = &q[1];
	return *p;
}

int main()
{
	char line[65536];
	char buf[1000000] = {0};
	char *last = buf;
	char *next = buf;

	while (gets(line)) {
		strcat(line, "\n");
		if (cmp(last, line)) continue;
		if (cmp(line, last)) next = buf;
		last = next;
		strcpy(next, line);
		while (*next) next = &next[1];
	}

	printf("%s", buf);
	return 0;
}
