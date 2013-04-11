/* 5432.c */

#include <openssl/bn.h>		/* BN_*() */
#include <openssl/err.h>	/* ERR_*() */
#include <stdlib.h>		/* exit() */
#include <stdio.h>		/* fprintf() */
#include <string.h>		/* strlen() */

void
fail(const char *message)
{
	fprintf(stderr, "%s: error 0x%08lx\n", ERR_get_error());
	exit(1);
}

int
main()
{
	BIGNUM two, three, four, five;
	BIGNUM answer;
	BN_CTX *context;
	size_t length;
	char *string;

	context = BN_CTX_new();
	if (context == NULL)
		fail("BN_CTX_new");

	/* answer = 5 ** 4 ** 3 ** 2 */
	BN_init(&two);
	BN_init(&three);
	BN_init(&four);
	BN_init(&five);
	if (BN_set_word(&two, 2) == 0 ||
	    BN_set_word(&three, 3) == 0 ||
	    BN_set_word(&four, 4) == 0 ||
	    BN_set_word(&five, 5) == 0)
		fail("BN_set_word");
	BN_init(&answer);
	if (BN_exp(&answer, &three, &two, context) == 0 ||
	    BN_exp(&answer, &four, &answer, context) == 0 ||
	    BN_exp(&answer, &five, &answer, context) == 0)
		fail("BN_exp");

	/* string = decimal answer */
	string = BN_bn2dec(&answer);
	if (string == NULL)
		fail("BN_bn2dec");

	length = strlen(string);
	printf(" First 20 digits: %.20s\n", string);
	if (length >= 20)
		printf("  Last 20 digits: %.20s\n", string + length - 20);
	printf("Number of digits: %zd\n", length);

	OPENSSL_free(string);
	BN_free(&answer);
	BN_free(&five);
	BN_free(&four);
	BN_free(&three);
	BN_free(&two);
	BN_CTX_free(context);

	return 0;
}
