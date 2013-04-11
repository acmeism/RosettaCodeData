#include <stdio.h>

char * base;
void get_diff()
{
	char x;
	if (base - &x < 200)
		printf("%p %d\n", &x, base - &x);
}

void recur()
{
	get_diff();
	recur();
}

int main()
{
	char v = 32;
	printf("pos of v: %p\n", base = &v);
	recur();
	return 0;
}
