#include <stdio.h>
#include <string.h>
#include <stddef.h>

void
allCharsSame(const char *s)
{
	const char *p;
	ptrdiff_t offs;

	printf("Input: \"%s\", length = %ld\n", s, strlen(s));

	for (p = s; *p; p++) {
		if (p[1] && p[0] != p[1]) {
			offs = &p[1] - s;
			/* +8 to skip past 'Input: "' */
			printf("%-*s^\n", (int)offs+8, "");
			printf("Difference at position %ld: '%c' (%#02x) != '%c' (%#02x)\n",
				offs, p[0], p[0], p[1], p[1]);
			return;
		}
	}
	printf("All characters are identical\n");
}

int
main(void)
{
	allCharsSame("");
	allCharsSame("   ");
	allCharsSame("2");
	allCharsSame("333");
	allCharsSame(".55");
	allCharsSame("tttTTT");
	allCharsSame("4444 444k");
	return 0;
}
