#include <gmp.h>

int main()
{
	mpz_t i;
	mpz_init(i); /* zero now */

	while (1) {
		mpz_add_ui(i, i, 1); /* i = i + 1 */
		gmp_printf("%Zd\n", i);
	}

	return 0;
}
