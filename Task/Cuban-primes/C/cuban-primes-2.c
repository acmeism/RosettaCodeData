#include <gmp.h>
#include <stdio.h>

typedef unsigned long int uint;

int main(void)
{
	mpz_t a, b;
	mpz_init(a);
	mpz_init(b);

	int found = 0;
	int col = 0;
	for (uint n = 1; ; n++) {
		mpz_ui_pow_ui(a, n, 3);
		mpz_ui_pow_ui(b, n + 1, 3);
		mpz_sub(a, b, a);

		if (!mpz_probab_prime_p(a, 5)) continue;

		if (++found <= 200) {
			gmp_printf("%10Zu", a);
			if (++col == 8) {
				putchar('\n');
				col = 0;
			}
		} else if (found == 100000) {
			gmp_printf("100000th: %Zu\n", a);
		} else if (found == 1000000) {
			gmp_printf("1000000th: %Zu\n", a);
			break;
		}
	}
	return 0;
}
