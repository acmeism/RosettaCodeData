#include <stdio.h>
#include <stdlib.h>

typedef unsigned uint;
typedef struct { uint i, v; } filt_t;

// ludics with at least so many elements and reach at least such value
uint* ludic(uint min_len, uint min_val, uint *len)
{
	uint cap, i, v, active = 1, nf = 0;
	filt_t *f = calloc(cap = 2, sizeof(*f));
	f[1].i = 4;

	for (v = 1; ; ++v) {
		for (i = 1; i < active && --f[i].i; i++);

		if (i < active)
			f[i].i = f[i].v;
		else if (nf == f[i].i)
			f[i].i = f[i].v, ++active;  // enable one more filter
		else {
			if (nf >= cap)
				f = realloc(f, sizeof(*f) * (cap*=2));
			f[nf] = (filt_t){ v + nf, v };
			if (++nf >= min_len && v >= min_val) break;
		}
	}

	// pack the sequence into a uint[]
	// filt_t struct was used earlier for cache locality in loops
	uint *x = (void*) f;
	for (i = 0; i < nf; i++) x[i] = f[i].v;
	x = realloc(x, sizeof(*x) * nf);

	*len = nf;
	return x;
}

int find(uint *a, uint v)
{
	uint i;
	for (i = 0; a[i] <= v; i++)
		if (v == a[i]) return 1;
	return 0;
}

int main(void)
{
	uint len, i, *x = ludic(2005, 1000, &len);

	printf("First 25:");
	for (i = 0; i < 25; i++) printf(" %u", x[i]);
	putchar('\n');

	for (i = 0; x[i] <= 1000; i++);
	printf("Ludics below 1000: %u\n", i);

	printf("Ludic 2000 to 2005:");
	for (i = 2000; i <= 2005; i++) printf(" %u", x[i - 1]);
	putchar('\n');

	printf("Triples below 250:");
	for (i = 0; x[i] + 6 <= 250; i++)
		if (find(x, x[i] + 2) && find(x, x[i] + 6))
			printf(" (%u %u %u)", x[i], x[i] + 2, x[i] + 6);

	putchar('\n');

	free(x);
	return 0;
}
