#include <stdio.h>

int valid(int n, int nuts)
{
	int k;
	for (k = n; k; k--, nuts -= 1 + nuts/n)
		if (nuts%n != 1) return 0;
	return nuts && !(nuts%n);
}

int main(void)
{
	int n, x;
	for (n = 2; n < 10; n++) {
		for (x = 0; !valid(n, x); x++);
		printf("%d: %d\n", n, x);
	}
	return 0;
}
