#include <stdio.h>
#include <limits.h>

typedef unsigned long long ull;
#define N  (sizeof(ull) * CHAR_BIT)
#define B(x) (1ULL << (x))

void evolve(ull state, int rule)
{
	int i;
	ull st;

	printf("Rule %d:\n", rule);
	do {
		st = state;
		for (i = N; i--; ) putchar(st & B(i) ? '#' : '.');
		putchar('\n');

		for (state = i = 0; i < N; i++)
			if (rule & B(7 & (st>>(i-1) | st<<(N+1-i))))
				state |= B(i);
	} while (st != state);
}

int main(int argc, char **argv)
{
	evolve(B(N/2), 90);
	evolve(B(N/4)|B(N - N/4), 30); // well, enjoy the fireworks

	return 0;
}
