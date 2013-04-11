#include <inttypes.h>
#include <stdio.h>

#include <openssl/err.h>
#include <openssl/rand.h>

int
main()
{
	uint32_t v;

	if (RAND_bytes((unsigned char *)&v, sizeof v) == 0) {
		ERR_print_errors_fp(stderr);
		return 1;
	}
	printf("%" PRIu32 "\n", v);
	return 0;
}
