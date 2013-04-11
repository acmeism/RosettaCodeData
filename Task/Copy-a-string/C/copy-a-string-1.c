#include <stdlib.h>	/* exit(), free() */
#include <stdio.h>	/* fputs(), perror(), printf() */
#include <string.h>

int
main()
{
	size_t len;
	char src[] = "Hello";
	char dst1[80], dst2[80];
	char *dst3, *ref;

	/*
	 * Option 1. Use strcpy() from <string.h>.
	 *
	 * DANGER! strcpy() can overflow the destination buffer.
	 * strcpy() is only safe if the source string is shorter than
	 * the destination buffer. We know that "Hello" (6 characters
	 * with the final '\0') easily fits in dst1 (80 characters).
	 */
	strcpy(dst1, src);

	/*
	 * Option 2. Use strlen() and memcpy() from <string.h>, to copy
	 * strlen(src) + 1 bytes including the final '\0'.
	 */
	len = strlen(src);
	if (len >= sizeof dst2) {
		fputs("The buffer is too small!\n", stderr);
		exit(1);
	}
	memcpy(dst2, src, len + 1);

	/*
	 * Option 3. Use strdup() from <string.h>, to allocate a copy.
	 */
	dst3 = strdup(src);
	if (dst3 == NULL) {
		/* Failed to allocate memory! */
		perror("strdup");
		exit(1);
	}

	/* Create another reference to the source string. */
	ref = src;

	/* Modify the source string, not its copies. */
	memset(src, '-', 5);

	printf(" src: %s\n", src);   /*  src: ----- */
	printf("dst1: %s\n", dst1);  /* dst1: Hello */
	printf("dst2: %s\n", dst2);  /* dst2: Hello */
	printf("dst3: %s\n", dst3);  /* dst3: Hello */
	printf(" ref: %s\n", ref);   /*  ref: ----- */

	/* Free memory from strdup(). */
	free(dst3);

	return 0;
}
