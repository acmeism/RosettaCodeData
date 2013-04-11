#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <wchar.h>

const char *sa = "abcdef";
const char *su = "as⃝df̅"; /* Should be in your native locale encoding. Mine is UTF-8 */

int is_comb(wchar_t c)
{
	if (c >= 0x300 && c <= 0x36f) return 1;
	if (c >= 0x1dc0 && c <= 0x1dff) return 1;
	if (c >= 0x20d0 && c <= 0x20ff) return 1;
	if (c >= 0xfe20 && c <= 0xfe2f) return 1;
	return 0;
}

wchar_t* mb_to_wchar(const char *s)
{
	wchar_t *u;
	size_t len = mbstowcs(0, s, 0) + 1;
	if (!len) return 0;

	u = malloc(sizeof(wchar_t) * len);
	mbstowcs(u, s, len);
	return u;
}

wchar_t* ws_reverse(const wchar_t* u)
{
	size_t len, i, j;
	wchar_t *out;
	for (len = 0; u[len]; len++);
	out = malloc(sizeof(wchar_t) * (len + 1));
	out[len] = 0;
	j = 0;
	while (len) {
		for (i = len - 1; i && is_comb(u[i]); i--);
		wcsncpy(out + j, u + i, len - i);
		j += len - i;
		len = i;
	}
	return out;
}

char *mb_reverse(const char *in)
{
	size_t len;
	char *out;
	wchar_t *u = mb_to_wchar(in);
	wchar_t *r = ws_reverse(u);
	len = wcstombs(0, r, 0) + 1;
	out = malloc(len);
	wcstombs(out, r, len);
	free(u);
	free(r);
	return out;
}

int main(void)
{
	setlocale(LC_CTYPE, "");

	printf("%s => %s\n", sa, mb_reverse(sa));
	printf("%s => %s\n", su, mb_reverse(su));
	return 0;
}
