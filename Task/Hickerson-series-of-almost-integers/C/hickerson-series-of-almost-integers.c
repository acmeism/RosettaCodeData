#include <stdio.h>
#include <mpfr.h>

void h(int n)
{
	MPFR_DECL_INIT(a, 200);
	MPFR_DECL_INIT(b, 200);

	mpfr_fac_ui(a, n, MPFR_RNDD);		// a = n!

	mpfr_set_ui(b, 2, MPFR_RNDD);		// b = 2
	mpfr_log(b, b, MPFR_RNDD);		// b = log(b)
	mpfr_pow_ui(b, b, n + 1, MPFR_RNDD);	// b = b^(n+1)

	mpfr_div(a, a, b, MPFR_RNDD);		// a = a / b
	mpfr_div_ui(a, a, 2, MPFR_RNDD);	// a = a / 2

	mpfr_frac(b, a, MPFR_RNDD);		// b = a - [a]
	mpfr_printf("%2d: %23.4Rf  %c\n", n, a,
		mpfr_cmp_d(b, .1) * mpfr_cmp_d(b, .9) > 0 ? 'Y' : 'N');
}

int main(void)
{
	int n;
	for (n = 1; n <= 17; n++) h(n);

	return 0;
}
