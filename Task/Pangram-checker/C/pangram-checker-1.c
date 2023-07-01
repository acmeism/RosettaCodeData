#include <stdio.h>

int is_pangram(const char *s)
{
	const char *alpha = ""
		"abcdefghjiklmnopqrstuvwxyz"
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	char ch, wasused[26] = {0};
	int total = 0;

	while ((ch = *s++) != '\0') {
		const char *p;
		int idx;

		if ((p = strchr(alpha, ch)) == NULL)
			continue;

		idx = (p - alpha) % 26;

		total += !wasused[idx];
		wasused[idx] = 1;
		if (total == 26)
			return 1;
	}
	return 0;
}

int main(void)
{
	int i;
	const char *tests[] = {
		"The quick brown fox jumps over the lazy dog.",
		"The qu1ck brown fox jumps over the lazy d0g."
	};

	for (i = 0; i < 2; i++)
		printf("\"%s\" is %sa pangram\n",
			tests[i], is_pangram(tests[i])?"":"not ");
	return 0;
}
