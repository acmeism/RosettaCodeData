#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef uint32_t pint;
typedef uint64_t xint;
typedef unsigned int uint;

int is_prime(xint);

inline int next_prime(pint p)
{
	if (p == 2) return 3;
	for (p += 2; p > 1 && !is_prime(p); p += 2);
	if (p == 1) return 0;
	return p;
}

int is_prime(xint n)
{
#	define NCACHE 256
#	define S (sizeof(uint) * 2)
	static uint cache[NCACHE] = {0};

	pint p = 2;
	int ofs, bit = -1;

	if (n < NCACHE * S) {
		ofs = n / S;
		bit = 1 << ((n & (S - 1)) >> 1);
		if (cache[ofs] & bit) return 1;
	}

	do {
		if (n % p == 0) return 0;
		if (p * p > n) break;
	} while ((p = next_prime(p)));

	if (bit != -1) cache[ofs] |= bit;
	return 1;
}

int decompose(xint n, pint *out)
{
	int i = 0;
	pint p = 2;
	while (n > p * p) {
		while (n % p == 0) {
			out[i++] = p;
			n /= p;
		}
		if (!(p = next_prime(p))) break;
	}
	if (n > 1) out[i++] = n;
	return i;
}

int main()
{
	int i, j, len;
	xint z;
	pint out[100];
	for (i = 2; i < 64; i = next_prime(i)) {
		z = (1ULL << i) - 1;
		printf("2^%d - 1 = %llu = ", i, z);
		fflush(stdout);
		len = decompose(z, out);
		for (j = 0; j < len; j++)
			printf("%u%s", out[j], j < len - 1 ? " x " : "\n");
	}

	return 0;
}
