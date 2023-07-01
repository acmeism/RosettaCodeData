#include <stdio.h>
#include <gmp.h>

#define N 100000
mpz_t p[N + 1];

void calc(int n)
{
	mpz_init_set_ui(p[n], 0);

	for (int k = 1; k <= n; k++) {
		int d = n - k * (3 * k - 1) / 2;
		if (d < 0) break;

		if (k&1)mpz_add(p[n], p[n], p[d]);
		else	mpz_sub(p[n], p[n], p[d]);

		d -= k;
		if (d < 0) break;

		if (k&1)mpz_add(p[n], p[n], p[d]);
		else	mpz_sub(p[n], p[n], p[d]);
	}
}

int main(void)
{
	int idx[] = { 23, 123, 1234, 12345, 20000, 30000, 40000, 50000, N, 0 };
	int at = 0;

	mpz_init_set_ui(p[0], 1);

	for (int i = 1; idx[at]; i++) {
		calc(i);
		if (i != idx[at]) continue;

		gmp_printf("%2d:\t%Zd\n", i, p[i]);
		at++;
	}
}
