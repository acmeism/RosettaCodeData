#include <stdio.h>
#include <stdlib.h>

typedef unsigned int uint;

int main(int argc, char **argv)
{
	uint top = atoi(argv[1]);
	uint *divsum = malloc((top + 1) * sizeof(*divsum));
	uint pows[32] = {1, 0};

	for (uint i = 0; i <= top; i++) divsum[i] = 1;

	// sieve
	for (uint p = 2; p <= top; p++) {
		if (divsum[p] > 1) continue; // p not prime

		uint x; // highest power of p we need

		// checking x <= top/y instead of x*y <= top to avoid overflow
		for (x = 1; pows[x - 1] <= top/p; x++)
			pows[x] = p*pows[x - 1];

		for (uint n = p; n <= top; n += p) {
			uint s;
			for (uint i = s = 1; i < x && !(n%pows[i]); s += pows[i++]);
			divsum[n] *= s;
		}
	}

	// subtract number itself from divisor sum ('proper')
	for (uint i = 0; i <= top; i++) divsum[i] -= i;

	for (uint a = 1; a <= top; a++) {
		uint b = divsum[a];
		if (b > a && b <= top && divsum[b] == a)
			printf("%u %u\n", a, b);
	}

	return 0;
}
