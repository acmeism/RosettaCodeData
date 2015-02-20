#include <gmp.h>

void perm(mpz_t out, int n, int k)
{
	mpz_set_ui(out, 1);
	k = n - k;
	while (n > k) mpz_mul_ui(out, out, n--);
}

void comb(mpz_t out, int n, int k)
{
	perm(out, n, k);
	while (k) mpz_divexact_ui(out, out, k--);
}

int main(void)
{
	mpz_t x;
	mpz_init(x);

	perm(x, 1000, 969);
	gmp_printf("P(1000,969) = %Zd\n", x);

	comb(x, 1000, 969);
	gmp_printf("C(1000,969) = %Zd\n", x);
	return 0;
}
