#include <stdio.h>
#include <limits.h>

typedef unsigned long long ull;
#define N (sizeof(ull) * CHAR_BIT)
#define B(x) (1ULL << (x))

void evolve(ull state, int rule)
{
	int i, p, q, b;

	for (p = 0; p < 10; p++) {
		for (b = 0, q = 8; q--; ) {
			ull st = state;
			b |= (st&1) << q;

			for (state = i = 0; i < N; i++)
				if (rule & B(7 & (st>>(i-1) | st<<(N+1-i))))
					state |= B(i);
		}
		printf(" %d", b);
	}
	putchar('\n');
	return;
}

int main(void)
{
	evolve(1, 30);
	return 0;
}
