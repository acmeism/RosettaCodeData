#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>

typedef struct node node;
struct node {
	int n;
	mpz_t v;
	node *next;
};

#define CSIZE 37
node *cache[CSIZE];

// very primitive linked hash table
node * find_cache(int n)
{
	int idx = n % CSIZE;
	node *p;

	for (p = cache[idx]; p && p->n != n; p = p->next);
	if (p) return p;

	p = malloc(sizeof(node));
	p->next = cache[idx];
	cache[idx] = p;

	if (n < 2) {
		p->n = n;
		mpz_init_set_ui(p->v, 1);
	} else {
		p->n = -1; // -1: value not computed yet
		mpz_init(p->v);
	}
	return p;
}

mpz_t tmp1, tmp2;
mpz_t *fib(int n)
{
	int x;
	node *p = find_cache(n);

	if (p->n < 0) {
		p->n = n;
		x = n / 2;

		mpz_mul(tmp1, *fib(x-1), *fib(n - x - 1));
		mpz_mul(tmp2, *fib(x), *fib(n - x));
		mpz_add(p->v, tmp1, tmp2);
	}
	return &p->v;
}

int main(int argc, char **argv)
{
	int i, n;
	if (argc < 2) return 1;

	mpz_init(tmp1);
	mpz_init(tmp2);

	for (i = 1; i < argc; i++) {
		n = atoi(argv[i]);
		if (n < 0) {
			printf("bad input: %s\n", argv[i]);
			continue;
		}

		// about 75% of time is spent in printing
		gmp_printf("%Zd\n", *fib(n));
	}
	return 0;
}
