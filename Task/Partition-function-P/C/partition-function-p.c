#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <gmp.h>

mpz_t* partition(uint64_t n) {
	mpz_t *pn = (mpz_t *)malloc((n + 2) * sizeof(mpz_t));
	mpz_init_set_ui(pn[0], 1);
	mpz_init_set_ui(pn[1], 1);
	for (uint64_t i = 2; i < n + 2; i ++) {
		mpz_init(pn[i]);
		for (uint64_t k = 1, penta; ; k++) {
			penta = k * (3 * k - 1) >> 1;
			if (penta >= i) break;
			if (k & 1) mpz_add(pn[i], pn[i], pn[i - penta]);
			else mpz_sub(pn[i], pn[i], pn[i - penta]);
			penta += k;
			if (penta >= i) break;
			if (k & 1) mpz_add(pn[i], pn[i], pn[i - penta]);
			else mpz_sub(pn[i], pn[i], pn[i - penta]);
		}
	}
	mpz_t *tmp = &pn[n + 1];
	for (uint64_t i = 0; i < n + 1; i ++) mpz_clear(pn[i]);
	free(pn);
	return tmp;
}

int main(int argc, char const *argv[]) {
	clock_t start = clock();
	mpz_t *p = partition(6666);
	gmp_printf("%Zd\n", p);
	printf("Elapsed time: %.04f seconds\n",
		(double)(clock() - start) / (double)CLOCKS_PER_SEC);
	return 0;
}
