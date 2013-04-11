#include <gmp.h>
#include <stdio.h>
#include <string.h>

int main()
{
	mpz_t a;
	mpz_init_set_ui(a, 5);
	mpz_pow_ui(a, a, 1 << 18); /* 2**18 == 4**9 */

	int len = mpz_sizeinbase(a, 10);
	printf("GMP says size is: %d\n", len);

	/* because GMP may report size 1 too big; see doc */
	char *s = mpz_get_str(0, 10, a);
	printf("size really is %d\n", len = strlen(s));
	printf("Digits: %.20s...%s\n", s, s + len - 20);

	// free(s); /* we could, but we won't. we are exiting anyway */
	return 0;
}
