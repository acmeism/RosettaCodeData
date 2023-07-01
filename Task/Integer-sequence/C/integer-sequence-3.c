#include <openssl/bn.h>		/* BN_*() */
#include <openssl/err.h>	/* ERR_*() */
#include <stdio.h>		/* fprintf(), puts() */

void
fail(const char *message)
{
	fprintf(stderr, "%s: error 0x%08lx\n", ERR_get_error());
	exit(1);
}

int
main()
{
	BIGNUM i;
	char *s;

	BN_init(&i);
	for (;;) {
		if (BN_add_word(&i, 1) == 0)
			fail("BN_add_word");
		s = BN_bn2dec(&i);
		if (s == NULL)
			fail("BN_bn2dec");
		puts(s);
		OPENSSL_free(s);
	}
	/* NOTREACHED */
}
