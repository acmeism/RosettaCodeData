#include <stdio.h>

int main()
{
	int i;
	for (i = 1; i * i <= 100; i++)
		printf("door %d open\n", i * i);

	return 0;
}
