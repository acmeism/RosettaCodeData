#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// ad hoc 128 bit integer type; faster than using GMP because of low
// overhead
typedef struct { uint64_t x[2]; } i128;

// display in decimal
void show(i128 v) {
	uint32_t x[4] = {v.x[0], v.x[0] >> 32, v.x[1], v.x[1] >> 32};
	int i, j = 0, len = 4;
	char buf[100];
	do {
		uint64_t c = 0;
		for (i = len; i--; ) {
			c = (c << 32) + x[i];
			x[i] = c / 10, c %= 10;
		}

		buf[j++] = c + '0';
		for (len = 4; !x[len - 1]; len--);
	} while (len);

	while (j--) putchar(buf[j]);
	putchar('\n');
}

i128 count(int sum, int *coins)
{
	int n, i, k;
	for (n = 0; coins[n]; n++);

	i128 **v = malloc(sizeof(int*) * n);
	int *idx = malloc(sizeof(int) * n);

	for (i = 0; i < n; i++) {
		idx[i] = coins[i];
		// each v[i] is a cyclic buffer
		v[i] = calloc(sizeof(i128), coins[i]);
	}

	v[0][coins[0] - 1] = (i128) {{1, 0}};

	for (k = 0; k <= sum; k++) {
		for (i = 0; i < n; i++)
			if (!idx[i]--) idx[i] = coins[i] - 1;

		i128 c = v[0][ idx[0] ];

		for (i = 1; i < n; i++) {
			i128 *p = v[i] + idx[i];

			// 128 bit addition
			p->x[0] += c.x[0];
			p->x[1] += c.x[1];
			if (p->x[0] < c.x[0]) // carry
				p->x[1] ++;
			c = *p;
		}
	}

	i128 r = v[n - 1][idx[n-1]];

	for (i = 0; i < n; i++) free(v[i]);
	free(v);
	free(idx);

	return r;
}

// simple recursive method; slow
int count2(int sum, int *coins)
{
	if (!*coins || sum < 0) return 0;
	if (!sum) return 1;
	return count2(sum - *coins, coins) + count2(sum, coins + 1);
}

int main(void)
{
	int us_coins[] = { 100, 50, 25, 10, 5, 1, 0 };
	int eu_coins[] = { 200, 100, 50, 20, 10, 5, 2, 1, 0 };

	show(count(   100, us_coins + 2));
	show(count(  1000, us_coins));

	show(count(  1000 * 100, us_coins));
	show(count( 10000 * 100, us_coins));
	show(count(100000 * 100, us_coins));

	putchar('\n');

	show(count(     1 * 100, eu_coins));
	show(count(  1000 * 100, eu_coins));
	show(count( 10000 * 100, eu_coins));
	show(count(100000 * 100, eu_coins));

	return 0;
}
