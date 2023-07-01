#include <stdio.h>
#include <string.h>

typedef struct { char v[16]; } deck;
typedef unsigned int uint;

uint n, d, best[16];

void tryswaps(deck *a, uint f, uint s) {
#	define A a->v
#	define B b.v
	if (d > best[n]) best[n] = d;
	while (1) {
		if ((A[s] == s || (A[s] == -1 && !(f & 1U << s)))
			&& (d + best[s] >= best[n] || A[s] == -1))
			break;

		if (d + best[s] <= best[n]) return;
		if (!--s) return;
	}

	d++;
	deck b = *a;
	for (uint i = 1, k = 2; i <= s; k <<= 1, i++) {
		if (A[i] != i && (A[i] != -1 || (f & k)))
			continue;

		for (uint j = B[0] = i; j--;) B[i - j] = A[j];
		tryswaps(&b, f | k, s);
	}
	d--;
}

int main(void) {
	deck x;
	memset(&x, -1, sizeof(x));
	x.v[0] = 0;

	for (n = 1; n < 13; n++) {
		tryswaps(&x, 1, n - 1);
		printf("%2d: %d\n", n, best[n]);
	}

	return 0;
}
