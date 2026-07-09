#include <gmp.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
	mpz_t result;
	unsigned long int n, m;
	char *sresult;

	mpz_init(result);

	for (n = 1; n <= 400; n++) {
		m = 0;

		while (1) {
			mpz_ui_pow_ui(result, 2, m);
			mpz_mul_ui(result, result, n);
			mpz_add_ui(result, result, 1);

			if (mpz_probab_prime_p(result, 40)) {
				sresult = (char *) malloc(mpz_sizeinbase(result, 10) + 1);

				if (!sresult) {
					fprintf(stderr, "Out of memory\n");
					exit(1);
				}

				printf("n = %ld,\tm = %ld,\tprime = %s\n", n, m, mpz_get_str(sresult, 10, result));
				free(sresult);

				break;
			}
			m += 1;
		}
	}

	mpz_clear(result);
	return 0;
}
