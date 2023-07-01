#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// we return a static buffer; caller wants it, caller copies it
char * mid3(int n)
{
	static char buf[32];
	int l;
	sprintf(buf, "%d", n > 0 ? n : -n);
	l = strlen(buf);
	if (l < 3 || !(l & 1)) return 0;
	l = l / 2 - 1;
	buf[l + 3] = 0;
	return buf + l;
}

int main(void)
{
	int x[] = {123, 12345, 1234567, 987654321, 10001, -10001,
		-123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0,
		1234567890};

	int i;
	char *m;
	for (i = 0; i < sizeof(x)/sizeof(x[0]); i++) {
		if (!(m = mid3(x[i])))
			m = "error";
		printf("%d: %s\n", x[i], m);
	}
	return 0;
}
