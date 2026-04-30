#include <stdio.h>
#include <stddef.h>
#include <limits.h>

struct ntd {
	size_t n;
	union {
		size_t      x;
		struct ntd *t;
	} u;
};
#define X(X) (struct ntd){ \
		.n = 0, \
		{ .x = (X) }\
	}
#define T(...) (struct ntd){ \
		.n = sizeof((struct ntd[]){__VA_ARGS__})/sizeof(struct ntd), \
		{ .t = (struct ntd[]){__VA_ARGS__} }\
	}

enum { UINT_BIT = sizeof(unsigned) * CHAR_BIT };
#define NUN(N)     (((N) + (UINT_BIT-1)) / UINT_BIT)
#define BIT(U,X)   ((U)[(X) / UINT_BIT] & (1u << ((X) % UINT_BIT)))
#define SET(U,X)   ((U)[(X) / UINT_BIT] |= (1u << ((X) % UINT_BIT)))

static void ntd_print(struct ntd t, char const *p[], unsigned u[]) {
	if(t.n > 0) {
		putchar('[');
		for(size_t i = 0; i < t.n; i++) {
			if(i > 0) {
				putchar(',');
			}
			ntd_print(t.u.t[i], p, u);
		}
		putchar(']');
	} else {
		printf("'%s'", p[t.u.x]);
		SET(u,t.u.x);
	}
}

int main(int argc, char **argv) {
	struct ntd t = T(
		T(T(X(1), X(2)),
		  T(X(3), X(4), X(1)),
		  X(5))
	);
	char const *p[] = {
		"Payload#0",
		"Payload#1",
		"Payload#2",
		"Payload#3",
		"Payload#4",
		"Payload#5",
		"Payload#6",
	};
	unsigned u[NUN(sizeof(p)/sizeof(*p))] = { 0 };
	ntd_print(t, p, u);
	putchar('\n');
	for(size_t i = 0; i < (sizeof(p)/sizeof(*p)); i++) {
		if(!BIT(u,i)) {
			printf("'%s' unused\n", p[i]);
		}
	}
	return 0;
}
