#include <stdio.h>
#include <gmp.h>

#define MAX_LEN 81

mpz_t power[10];
mpz_t dsum[MAX_LEN + 1];
int cnt[10], len;

void check_perm(void)
{
	char s[MAX_LEN + 1];
	int i, c, out[10] = { 0 };

	mpz_get_str(s, 10, dsum[0]);
	for (i = 0; s[i]; i++) {
		c = s[i]-'0';
		if (++out[c] > cnt[c]) return;
	}

	if (i == len)
		gmp_printf(" %Zd", dsum[0]);
}

void narc_(int pos, int d)
{
	if (!pos) {
		check_perm();
		return;
	}

	do {
		mpz_add(dsum[pos-1], dsum[pos], power[d]);
		++cnt[d];
		narc_(pos - 1, d);
		--cnt[d];
	} while (d--);
}

void narc(int n)
{
	int i;
	len = n;
	for (i = 0; i < 10; i++)
		mpz_ui_pow_ui(power[i], i, n);

	mpz_init_set_ui(dsum[n], 0);

	printf("length %d:", n);
	narc_(n, 9);
	putchar('\n');
}

int main(void)
{
	int i;

	for (i = 0; i <= 10; i++)
		mpz_init(power[i]);
	for (i = 1; i <= MAX_LEN; i++) narc(i);

	return 0;
}
