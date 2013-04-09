#include <stdio.h>

void bin(int x, char *s)
{
	char*_(int x){
		*(s = x ? _(x >> 1) : s) = (x & 1) + '0';
		return ++s;
	}
	*_(x) = 0;
}

int main()
{
	char a[100];
	int i;
	for (i = 0; i <= 1984; i += 31)
		bin(i, a), printf("%4d: %s\n", i, a);

	return 0;
}
