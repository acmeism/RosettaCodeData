#include <stdio.h>

int pangram(const char *s)
{
	int c, mask = (1 << 26) - 1;
	while ((c = (*s++)) != '\0') /* 0x20 converts lowercase to upper */
		if ((c &= ~0x20) <= 'Z' && c >= 'A')
			mask &= ~(1 << (c - 'A'));

	return !mask;
}

int main()
{
	int i;
	const char *s[] = {	"The quick brown fox jumps over lazy dogs.",
				"The five boxing wizards dump quickly.",  };

	for (i = 0; i < 2; i++)
		printf("%s: %s\n", pangram(s[i]) ? "yes" : "no ", s[i]);

	return 0;
}
