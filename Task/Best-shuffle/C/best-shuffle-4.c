#include <stdio.h>
#include <string.h>

#define FOR(x, y) for(x = 0; x < y; x++)
char *best_shuffle(const char *s, int *diff)
{
	int i, j = 0, max = 0, l = strlen(s), cnt[128] = {0};
	char buf[256] = {0}, *r;

	FOR(i, l) if (++cnt[(int)s[i]] > max) max = cnt[(int)s[i]];
	FOR(i, 128) while (cnt[i]--) buf[j++] = i;

	r = strdup(s);
	FOR(i, l) FOR(j, l)
		if (r[i] == buf[j]) {
			r[i] = buf[(j + max) % l] & ~128;
			buf[j] |= 128;
			break;
		}

	*diff = 0;
	FOR(i, l) *diff += r[i] == s[i];

	return r;
}

int main()
{
	int i, d;
	const char *r, *t[] = {"abracadabra", "seesaw", "elk", "grrrrrr", "up", "a", 0};
	for (i = 0; t[i]; i++) {
		r = best_shuffle(t[i], &d);
		printf("%s %s (%d)\n", t[i], r, d);
	}
	return 0;
}
