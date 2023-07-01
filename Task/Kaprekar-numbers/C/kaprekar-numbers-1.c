#include <stdio.h>
#include <stdint.h>
typedef uint64_t ulong;

int kaprekar(ulong n, int base)
{
	ulong nn = n * n, r, tens = 1;

	if ((nn - n) % (base - 1)) return 0;

	while (tens < n) tens *= base;
	if (n == tens) return 1 == n;

	while ((r = nn % tens) < n) {
		if (nn / tens + r == n) return tens;
		tens *= base;
	}

	return 0;
}

void print_num(ulong n, int base)
{
	ulong q, div = base;

	while (div < n) div *= base;
	while (n && (div /= base)) {
		q = n / div;
		if (q < 10)     putchar(q + '0');
		else            putchar(q + 'a' - 10);
		n -= q * div;
	}
}

int main()
{
	ulong i, tens;
	int cnt = 0;
	int base = 10;

	printf("base 10:\n");
	for (i = 1; i < 1000000; i++)
		if (kaprekar(i, base))
			printf("%3d: %llu\n", ++cnt, i);

	base = 17;
	printf("\nbase %d:\n  1: 1\n", base);
	for (i = 2, cnt = 1; i < 1000000; i++)
		if ((tens = kaprekar(i, base))) {
			printf("%3d: %llu", ++cnt, i);
			printf(" \t"); print_num(i, base);
			printf("\t");  print_num(i * i, base);
			printf("\t");  print_num(i * i / tens, base);
			printf(" + "); print_num(i * i % tens, base);
			printf("\n");
		}

	return 0;
}
