#include <stdlib.h>
#include <stdio.h>

#define SWAP(a, b) (((a) ^= (b)), ((b) ^= (a)), ((a) ^= (b)))

int jacobi(unsigned long a, unsigned long n) {
	if (a >= n) a %= n;
	int result = 1;
	while (a) {
		while ((a & 1) == 0) {
			a >>= 1;
			if ((n & 7) == 3 || (n & 7) == 5) result = -result;
		}
		SWAP(a, n);
		if ((a & 3) == 3 && (n & 3) == 3) result = -result;
		a %= n;
	}
	if (n == 1) return result;
	return 0;
}

void print_table(unsigned kmax, unsigned nmax) {
	printf("n\\k|");
	for (int k = 0; k <= kmax; ++k) printf("%'3u", k);
	printf("\n----");
	for (int k = 0; k <= kmax; ++k) printf("---");
	putchar('\n');
	for (int n = 1; n <= nmax; n += 2) {
		printf("%-2u |", n);
		for (int k = 0; k <= kmax; ++k)
			printf("%'3d", jacobi(k, n));
		putchar('\n');
	}
}

int main() {
	print_table(20, 21);
	return 0;
}
