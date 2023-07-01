#include <stdlib.h>	/* exit() */
#include <stdio.h>	/* fputs(), printf() */
#include <string.h>

int
main()
{
	char src[] = "Hello";
	char dst[80];

	/* Use strlcpy() from <string.h>. */
	if (strlcpy(dst, src, sizeof dst) >= sizeof dst) {
		fputs("The buffer is too small!\n", stderr);
		exit(1);
	}

	memset(src, '-', 5);
	printf("src: %s\n", src);  /* src: ----- */
	printf("dst: %s\n", dst);  /* dst: Hello */

	return 0;
}
