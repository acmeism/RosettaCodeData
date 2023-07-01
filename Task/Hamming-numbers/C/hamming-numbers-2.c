#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <gmp.h>

/* number of factors.  best be mutually prime -- duh. */
#define NK 3
#define MAX_HAM (1 << 24)
#define MAX_POW 1024
int n_hams = 0, idx[NK] = {0}, fac[] = { 2, 3, 5, 7, 11};

/*  k-smooth numbers are stored as their exponents of each factor;
    v is the log of the number, for convenience. */
typedef struct {
	int e[NK];
	double v;
} ham_t, *ham;

ham_t *hams, values[NK] = {{{0}, 0}};
double inc[NK][MAX_POW];

/* most of the time v can be just incremented, but eventually
 * floating point precision will bite us, so better recalculate */
inline
void _setv(ham x) {
	int i;
	for (x->v = 0, i = 0; i < NK; i++)
		x->v += inc[i][x->e[i]];
}

inline
int _eq(ham a, ham b) {
	int i;
	for (i = 0; i < NK && a->e[i] == b->e[i]; i++);

	return i == NK;
}

ham get_ham(int n)
{
	int i, ni;
	ham h;

	n--;
	while (n_hams < n) {
		for (ni = 0, i = 1; i < NK; i++)
			if (values[i].v < values[ni].v)
				ni = i;

		*(h = hams + ++n_hams) = values[ni];

		for (ni = 0; ni < NK; ni++) {
			if (! _eq(values + ni, h)) continue;
			values[ni] = hams[++idx[ni]];
			values[ni].e[ni]++;
			_setv(values + ni);
		}
	}

	return hams + n;
}

void show_ham(ham h)
{
	static mpz_t das_ham, tmp;
	int i;

 	mpz_init_set_ui(das_ham, 1);
	mpz_init_set_ui(tmp, 1);
	for (i = 0; i < NK; i++) {
		mpz_ui_pow_ui(tmp, fac[i], h->e[i]);
		mpz_mul(das_ham, das_ham, tmp);
	}
	gmp_printf("%Zu\n", das_ham);
}

int main()
{
	int i, j;
	hams = malloc(sizeof(ham_t) * MAX_HAM);

	for (i = 0; i < NK; i++) {
		values[i].e[i] = 1;
		inc[i][1] = log(fac[i]);
		_setv(values + i);

		for (j = 2; j < MAX_POW; j++)
			inc[i][j] = j * inc[i][1];
	}

	printf("     1,691: "); show_ham(get_ham(1691));
	printf(" 1,000,000: "); show_ham(get_ham(1e6));
	printf("10,000,000: "); show_ham(get_ham(1e7));
	return 0;
}
