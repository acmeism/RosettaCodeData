#include <stdio.h>

int isPangram(const char *string)
{
	char ch, wasused[26] = {0};
	int total = 0;

	while ((ch = *string++)) {
		int index;

		if('A'<=ch&&ch<='Z')
			index = ch-'A';
		else if('a'<=ch&&ch<='z')
			index = ch-'a';
		else
			continue;

		total += !wasused[index];
		wasused[index] = 1;
	}
	return (total==26);
}

int main()
{
	int i;
	const char *tests[] = {
		"The quick brown fox jumps over the lazy dog.",
		"The qu1ck brown fox jumps over the lazy d0g."
	};

	for (i = 0; i < 2; i++)
		printf("\"%s\" is %sa pangram\n",
			tests[i], isPangram(tests[i])?"":"not ");
	return 0;
}
