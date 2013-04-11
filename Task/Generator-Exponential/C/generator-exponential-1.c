#include <inttypes.h>	/* int64_t, PRId64 */
#include <stdlib.h>	/* exit() */
#include <stdio.h>	/* printf() */

#include <libco.h>	/* co_{active,create,delete,switch}() */



/* A generator that yields values of type int64_t. */
struct gen64 {
	cothread_t giver;	/* this cothread calls yield64() */
	cothread_t taker;	/* this cothread calls next64() */
	int64_t given;
	void (*free)(struct gen64 *);
	void *garbage;
};

/* Yields a value. */
inline void
yield64(struct gen64 *gen, int64_t value)
{
	gen->given = value;
	co_switch(gen->taker);
}

/* Returns the next value that the generator yields. */
inline int64_t
next64(struct gen64 *gen)
{
	gen->taker = co_active();
	co_switch(gen->giver);
	return gen->given;
}

static void
gen64_free(struct gen64 *gen)
{
	co_delete(gen->giver);
}

struct gen64 *entry64;

/*
 * Creates a cothread for the generator. The first call to next64(gen)
 * will enter the cothread; the entry function must copy the pointer
 * from the global variable struct gen64 *entry64.
 *
 * Use gen->free(gen) to free the cothread.
 */
inline void
gen64_init(struct gen64 *gen, void (*entry)(void))
{
	if ((gen->giver = co_create(4096, entry)) == NULL) {
		/* Perhaps malloc() failed */
		fputs("co_create: Cannot create cothread\n", stderr);
		exit(1);
	}
	gen->free = gen64_free;
	entry64 = gen;
}



/*
 * Generates the powers 0**m, 1**m, 2**m, ....
 */
void
powers(struct gen64 *gen, int64_t m)
{
	int64_t base, exponent, n, result;

	for (n = 0;; n++) {
		/*
		 * This computes result = base**exponent, where
		 * exponent is a nonnegative integer. The result
		 * is the product of repeated squares of base.
		 */
		base = n;
		exponent = m;
		for (result = 1; exponent != 0; exponent >>= 1) {
			if (exponent & 1) result *= base;
			base *= base;
		}
		yield64(gen, result);
	}
	/* NOTREACHED */
}

/* stuff for squares_without_cubes() */
#define ENTRY(name, code) static void name(void) { code; }
ENTRY(enter_squares, powers(entry64, 2))
ENTRY(enter_cubes, powers(entry64, 3))

struct swc {
	struct gen64 cubes;
	struct gen64 squares;
	void (*old_free)(struct gen64 *);
};

static void
swc_free(struct gen64 *gen)
{
	struct swc *f = gen->garbage;
	f->cubes.free(&f->cubes);
	f->squares.free(&f->squares);
	f->old_free(gen);
}

/*
 * Generates the squares 0**2, 1**2, 2**2, ..., but removes the squares
 * that equal the cubes 0**3, 1**3, 2**3, ....
 */
void
squares_without_cubes(struct gen64 *gen)
{
	struct swc f;
	int64_t c, s;

	gen64_init(&f.cubes, enter_cubes);
	c = next64(&f.cubes);

	gen64_init(&f.squares, enter_squares);
	s = next64(&f.squares);

	/* Allow other cothread to free this generator. */
	f.old_free = gen->free;
	gen->garbage = &f;
	gen->free = swc_free;

	for (;;) {
		while (c < s)
			c = next64(&f.cubes);
		if (c != s)
			yield64(gen, s);
		s = next64(&f.squares);
	}
	/* NOTREACHED */
}

ENTRY(enter_squares_without_cubes, squares_without_cubes(entry64))

/*
 * Look at the sequence of numbers that are squares but not cubes.
 * Drop the first 20 numbers, then print the next 10 numbers.
 */
int
main()
{
	struct gen64 gen;
	int i;

	gen64_init(&gen, enter_squares_without_cubes);

	for (i = 0; i < 20; i++)
		next64(&gen);
	for (i = 0; i < 9; i++)
		printf("%" PRId64 ", ", next64(&gen));
	printf("%" PRId64 "\n", next64(&gen));

	gen.free(&gen); /* Free memory. */
	return 0;
}
