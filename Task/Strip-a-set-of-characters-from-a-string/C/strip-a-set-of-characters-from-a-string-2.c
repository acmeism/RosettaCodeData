#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *strip(const char * str, const char *pat)
{
	/*  char replacement is typically done with lookup tables if
	 *  the replacement set can be large: it turns O(m n) into
	 *  O(m + n).
	 *  If same replacement pattern is going to be applied to many
	 *  strings, it's better to build a table beforehand and reuse it.
	 *  If charset is big like unicode, table needs to be implemented
	 *  more efficiently, say using bit field or hash table -- it
	 *  all depends on the application.
	 */
	int i = 0, tbl[128] = {0};
	while (*pat != '\0') tbl[(int)*(pat++)] = 1;

	char *ret = malloc(strlen(str));
	do {
		if (!tbl[(int)*str])
			ret[i++] = *str;
	} while (*(str++) != '\0');

	/*  assuming realloc is efficient and succeeds; if not, we could
	 *  do a two-pass, count first, alloc and strip second
	 */
	return realloc(ret, i);
}

int main()
{
	char * x = strip("She was a soul stripper. She took my heart!", "aei");
	printf(x);
	free(x);

	return 0;
}
