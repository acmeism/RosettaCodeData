#include <gmp.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_BRANCH 4
#define MAX_N 500

mpz_t bcache[MAX_N + 1];
mpz_t ucache[MAX_N + 1];
mpz_t *rcache[MAX_N + 1][MAX_BRANCH + 1];

mpz_t tmp1, tmp2;
void choose(mpz_t r, mpz_t m, int k)
{
	int i;
	mpz_set(r, m);

	mpz_add_ui(tmp1, m, 1);
	for (i = 1; i < k; ) {
		mpz_mul(r, r, tmp1);
		mpz_divexact_ui(r, r, ++i);

		if (i >= k) break;
		mpz_add_ui(tmp1, tmp1, 1);
	}
}

mpz_t rtmp1, rtmp2;
void calc_rooted(mpz_t res, int n, int b, int r)
{
	mpz_set_ui(res, 0);

	if (n == 1 && b == 0 && r == 0) {
		mpz_set_ui(res, 1);
		return;
	} else if (n <= b || n <= r || n == 1 || b == 0 || r == 0)
		return;

	int b1, r1;
	for (b1 = 1; b1 <= b && r * b1 < n; b1++) {
		choose(rtmp1, bcache[r], b1);
		mpz_set_ui(rtmp2, 0);
		for (r1 = 0; r1 < r && r1 + r * b1 < n; r1++)
			mpz_add(rtmp2, rtmp2, rcache[n - r * b1][b - b1][r1]);
		
		mpz_addmul(res, rtmp1, rtmp2);
	}
}

void calc_first_branch(int n)
{
	int b, r;
	mpz_init_set_ui(bcache[n], 0);

	for (b = 0; b < MAX_BRANCH; b++)
		for (r = 0; r < n; r++)
			mpz_add(bcache[n], bcache[n], rcache[n][b][r]);
}

void calc_unrooted(int n)
{
	int b, r;

	for (b = 0; b <= MAX_BRANCH; b++) {
		mpz_t *p = malloc(sizeof(mpz_t) * n);
		rcache[n][b] = p;
		for (r = 0; r < n; r++) {
			mpz_init(p[r]);
			calc_rooted(p[r], n, b, r);
		}
	}

	calc_first_branch(n);

	mpz_init_set_ui(ucache[n], 0);
	for (r = 0; r * 2 < n; r++)
		for (b = 0; b <= MAX_BRANCH; b++)
			mpz_add(ucache[n], ucache[n], rcache[n][b][r]);
	
	if (!(n & 1)) {
		mpz_add_ui(rtmp1, bcache[n/2], 1);
		mpz_mul(rtmp1, rtmp1, bcache[n/2]);
		mpz_divexact_ui(rtmp1, rtmp1, 2);
		mpz_add(ucache[n], ucache[n], rtmp1);
	}
}

void init(void)
{
	mpz_init(tmp1), mpz_init(tmp2);
	mpz_init(rtmp1), mpz_init(rtmp2);
}

int main(void)
{
	int i;

	init();

	for (i = 0; i <= MAX_N; i++) {
		calc_unrooted(i);
		gmp_printf("%d: %Zd\n", i, ucache[i]);
	}

	return 0;
}
