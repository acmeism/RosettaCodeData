#include <stdio.h>

#define s(x) (1U << ((x) - 'A'))

typedef unsigned int bitset;

int consolidate(bitset *x, int len)
{
	int i, j;
	for (i = len - 2; i >= 0; i--)
		for (j = len - 1; j > i; j--)
			if (x[i] & x[j])
				x[i] |= x[j], x[j] = x[--len];
	return len;
}

void show_sets(bitset *x, int len)
{
	bitset b;
	while(len--) {
		for (b = 'A'; b <= 'Z'; b++)
			if (x[len] & s(b)) printf("%c ", b);
		putchar('\n');
	}
}

int main(void)
{
	bitset x[] = { s('A') | s('B'), s('C') | s('D'), s('B') | s('D'),
			s('F') | s('G') | s('H'), s('H') | s('I') | s('K') };

	int len = sizeof(x) / sizeof(x[0]);

	puts("Before:"); show_sets(x, len);
	puts("\nAfter:"); show_sets(x, consolidate(x, len));
	return 0;
}
