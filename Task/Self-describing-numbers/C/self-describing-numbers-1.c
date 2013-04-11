#include <stdio.h>

int self_desc(const char *s)
{
	unsigned char cnt[10] = {0};
	int i;
	for (i = 0; s[i] != '\0'; i++) cnt[s[i] - '0']++;
	for (i = 0; s[i] != '\0'; i++) if (cnt[i] + '0' != s[i]) return 0;
	return 1;
}

void gen(int n)
{
	char d[11];
	int one, i;
	/* one = 0 may be confusing.  'one' is the number of digit 1s */
	for (one = 0; one <= 2 && one < n - 2; one++) {
		for (i = 0; i <= n; d[i++] = 0);

		if ((d[0] = n - 2 - one) != 2) {
			d[2] = d[d[0] - 0] = 1;
			d[1] = 2;
		} else {
			d[1] = one ? 1 : 0;
			d[2] = 2;
		}

		for (i = 0; i < n; d[i++] += '0');
		if (self_desc(d)) printf("%s\n", d);
	}
}

int main()
{
	int i;
	const char *nums[] = { "1210", "1337", "2020", "21200", "3211000", "42101000", 0};

	for (i = 0; nums[i]; i++)
		printf("%s is %sself describing\n", nums[i],
			self_desc(nums[i]) ? "" : "not ");

	printf("\nAll autobiograph numbers:\n");
	for (i = 0; i < 11; i++) gen(i);
	return 0;
}
