#include <stdio.h>
#include <stdlib.h>

#define IS_CTRL  (1 << 0)
#define IS_EXT	 (1 << 1)
#define IS_ALPHA (1 << 2)
#define IS_DIGIT (1 << 3) /* not used, just give you an idea */

unsigned int char_tbl[256] = {0};

/* could use ctypes, but then they pretty much do the same thing */
void init_table()
{
	int i;

	for (i = 0; i < 32; i++) char_tbl[i] |= IS_CTRL;
	char_tbl[127] |= IS_CTRL;

	for (i = 'A'; i <= 'Z'; i++) {
		char_tbl[i] |= IS_ALPHA;
		char_tbl[i + 0x20] |= IS_ALPHA; /* lower case */
	}

	for (i = 128; i < 256; i++) char_tbl[i] |= IS_EXT;
}

/* depends on what "stripped" means; we do it in place.
 * "what" is a combination of the IS_* macros, meaning strip if
 * a char IS_ any of them
 */
void strip(char * str, int what)
{
	unsigned char *ptr, *s = (void*)str;
	ptr = s;
	while (*s != '\0') {
		if ((char_tbl[(int)*s] & what) == 0)
			*(ptr++) = *s;
		s++;
	}
	*ptr = '\0';
}

int main()
{
	char a[256];
	int i;

	init_table();

	/* populate string with one of each char */
	for (i = 1; i < 255; i++) a[i - 1] = i; a[255] = '\0';
	strip(a, IS_CTRL);
	printf("%s\n", a);

	for (i = 1; i < 255; i++) a[i - 1] = i; a[255] = '\0';
	strip(a, IS_CTRL | IS_EXT);
	printf("%s\n", a);

	for (i = 1; i < 255; i++) a[i - 1] = i; a[255] = '\0';
	strip(a, IS_CTRL | IS_EXT | IS_ALPHA);
	printf("%s\n", a);

	return 0;
}
