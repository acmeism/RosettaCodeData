#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

typedef struct frac_s *frac;
struct frac_s {
	int n, d;
	frac next;
};

frac parse(char *s)
{
	int offset = 0;
	struct frac_s h = {0}, *p = &h;

	while (2 == sscanf(s, "%d/%d%n", &h.n, &h.d, &offset)) {
		s += offset;
		p = p->next = malloc(sizeof *p);
		*p = h;
		p->next = 0;
	}

	return h.next;
}

int run(int v, char *s)
{
	frac n, p = parse(s);
	mpz_t val;
	mpz_init_set_ui(val, v);

loop:	n = p;
	if (mpz_popcount(val) == 1)
		gmp_printf("\n[2^%d = %Zd]", mpz_scan1(val, 0), val);
	else
		gmp_printf(" %Zd", val);

	for (n = p; n; n = n->next) {
		// assuming the fractions are not reducible
		if (!mpz_divisible_ui_p(val, n->d)) continue;

		mpz_divexact_ui(val, val, n->d);
		mpz_mul_ui(val, val, n->n);
		goto loop;
	}

	gmp_printf("\nhalt: %Zd has no divisors\n", val);

	mpz_clear(val);
	while (p) {
		n = p->next;
		free(p);
		p = n;
	}

	return 0;
}

int main(void)
{
	run(2,	"17/91 78/85 19/51 23/38 29/33 77/29 95/23 "
		"77/19 1/17 11/13 13/11 15/14 15/2 55/1");

	return 0;
}
