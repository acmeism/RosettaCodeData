#include <stdio.h>

int common_len(const char *const *names, int n, char sep)
{
	int i, pos;
	for (pos = 0; ; pos++) {
		for (i = 0; i < n; i++) {
			if (names[i][pos] != '\0' &&
					names[i][pos] == names[0][pos])
				continue;

			/* backtrack */
			while (pos > 0 && names[0][--pos] != sep);
			return pos;
		}
	}

	return 0;
}

int main()
{
	const char *names[] = {
		"/home/user1/tmp/coverage/test",
		"/home/user1/tmp/covert/operator",
		"/home/user1/tmp/coven/members",
	};
	int len = common_len(names, sizeof(names) / sizeof(const char*), '/');

	if (!len) printf("No common path\n");
	else      printf("Common path: %.*s\n", len, names[0]);

	return 0;
}
