#include <stdio.h>

typedef unsigned long long ull;

int is89(int x)
{
	while (1) {
		int s = 0;
		do s += (x%10)*(x%10); while ((x /= 10));

		if (s == 89) return 1;
		if (s == 1) return 0;
		x = s;
	}
}


int main(void)
{
	// array bounds is sort of random here, it's big enough for 64bit unsigned.
	ull sums[32*81 + 1] = {1, 0};

	for (int n = 1; ; n++) {
		for (int i = n*81; i; i--) {
			for (int j = 1; j < 10; j++) {
				int s = j*j;
				if (s > i) break;
				sums[i] += sums[i-s];
			}
		}

		ull count89 = 0;
		for (int i = 1; i < n*81 + 1; i++) {
			if (!is89(i)) continue;

			if (sums[i] > ~0ULL - count89) {
				printf("counter overflow for 10^%d\n", n);
				return 0;
			}
			count89 += sums[i];
		}

		printf("1->10^%d: %llu\n", n, count89);
	}

	return 0;
}
