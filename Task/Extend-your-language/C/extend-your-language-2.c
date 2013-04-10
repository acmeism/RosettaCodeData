#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "if2.h"

int main(int argc, char *argv[]) {
	int i;
	for (i = 1; i < argc; i++) {
		char *arg= argv[i], *ep;
		long lval = strtol(arg, &ep, 10); /* convert arg to long */
		if2 (arg[0] == '\0', *ep == '\0'
			, puts("empty string")
			, puts("empty string")
			, if2 (lval > 10, lval > 100
				, printf("%s: a very big number\n", arg)
				, printf("%s: a big number\n", arg)
				, printf("%s: a very big number\n", arg)
				, printf("%s: a number\n", arg)
			)
			, printf("%s: not a number\n", arg)
		)
	}
	return 0;
}
