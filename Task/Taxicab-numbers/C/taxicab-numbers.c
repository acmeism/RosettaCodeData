#include <stdio.h>
#include <stdlib.h>

typedef unsigned long long xint;
typedef unsigned uint;
typedef struct {
	uint x, y; // x > y always
	xint value;
} sum_t;

xint *cube;
uint n_cubes;

sum_t *pq;
uint pq_len, pq_cap;

void add_cube(void)
{
	uint x = n_cubes++;
	cube = realloc(cube, sizeof(xint) * (n_cubes + 1));
	cube[n_cubes] = (xint) n_cubes*n_cubes*n_cubes;
	if (x < 2) return; // x = 0 or 1 is useless

	if (++pq_len >= pq_cap) {
		if (!(pq_cap *= 2)) pq_cap = 2;
		pq = realloc(pq, sizeof(*pq) * pq_cap);
	}

	sum_t tmp = (sum_t) { x, 1, cube[x] + 1 };
	// upheap
	uint i, j;
	for (i = pq_len; i >= 1 && pq[j = i>>1].value > tmp.value; i = j)
		pq[i] = pq[j];

	pq[i] = tmp;
}

void next_sum(void)
{
redo:	while (!pq_len || pq[1].value >= cube[n_cubes]) add_cube();

	sum_t tmp = pq[0] = pq[1];	// pq[0] always stores last seen value
	if (++tmp.y >= tmp.x) {		// done with this x; throw it away
		tmp = pq[pq_len--];
		if (!pq_len) goto redo;	// refill empty heap
	} else
		tmp.value += cube[tmp.y] - cube[tmp.y-1];

	uint i, j;
	// downheap
	for (i = 1; (j = i<<1) <= pq_len; pq[i] = pq[j], i = j) {
		if (j < pq_len && pq[j+1].value < pq[j].value) ++j;
		if (pq[j].value >= tmp.value) break;
	}
	pq[i] = tmp;
}

uint next_taxi(sum_t *hist)
{
	do next_sum(); while (pq[0].value != pq[1].value);

	uint len = 1;
	hist[0] = pq[0];
	do {
		hist[len++] = pq[1];
		next_sum();
	} while (pq[0].value == pq[1].value);

	return len;
}

int main(void)
{
	uint i, l;
	sum_t x[10];
	for (i = 1; i <= 2006; i++) {
		l = next_taxi(x);
		if (25 < i && i < 2000) continue;
		printf("%4u:%10llu", i, x[0].value);
		while (l--) printf(" = %4u^3 + %4u^3", x[l].x, x[l].y);
		putchar('\n');
	}
	return 0;
}
