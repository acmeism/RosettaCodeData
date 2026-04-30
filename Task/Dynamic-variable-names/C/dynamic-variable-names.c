#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <float.h>

static inline uint64_t hash(void const *cp, size_t n) {
	uint64_t       h = 0;
	uint64_t const e = UINT64_C(2718281828459045235);  // e * 10**18
	for(uint8_t const *cb = cp; n > 0; n--) {
		h = ((h + n) * e) ^ ((*cb++ & 0xFF) * e);
	}
	return h;
}

static void *dup(void const *cp, size_t n) {
	void *p = malloc(n);
	return memcpy(p, cp, n);
}

static void *nodup(void const *cp, size_t n) {
	return (void*)cp;
}

#define MAPPED  struct mapped_s
MAPPED {
	size_t      n;
	char const *s;
};
#define MAP  struct map_s
MAP {
	size_t u;
	size_t w;
	size_t m;
	char   a[];
};

static MAP *map_alloc(size_t m, size_t z) {
	const size_t N = (((m * z) + (sizeof(MAP)-1)) / sizeof(MAP)) + 1;
	MAP *t = calloc(N, sizeof(MAP));
	t->m = m;
	t->w = 3 * m / 4;
	return t;
}

static void *map(MAP **t, size_t z, char const *s, size_t n, void *(*dup)(void const *, size_t)) {
	if(!*t) {
		*t = map_alloc(sizeof(size_t) * CHAR_BIT, z);
	}
	MAP        *f = *t;
	uint64_t const h = hash(s, n);
	size_t         x = (h / f->m) % f->m;
	size_t   const k = x + !x;
	size_t   const l = f->m - k;
	size_t   const y = h % f->m;
	x = y;
	do {
		MAPPED *p = (MAPPED *)&f->a[x*z];
		if((p->n == n) && (memcmp(p->s, s, n) == 0)) {
			return p;
		}
		if((p->n == 0) && dup) {
			if(f->u == f->w) {
				*t = map_alloc(2 * f->m, z);
				for(size_t i = 0; f->u < f->w; i++) {
					MAPPED *q = (MAPPED *)&f->a[i*z];
					if(q->n > 0) {
						(void)map(t, z, q->s, q->n, nodup);
					}
				}
				free(f);
				return map(t, z, s, n, dup);
			}
			f->u++;
			p->n = n;
			p->s = dup(s, n);
			return p;
		}
		x = (x >= l) ? ((x + 1) % k) : (x + k);
	} while(x != y)
		;
	return NULL;
}

static double mapf(char const *s, double v, void *(*dup)(void const *, size_t)) {
	static MAP *t = NULL;
	struct {
		MAPPED;
		double v;
	} *p = map(&t, sizeof(*p), s, strlen(s), dup);
	if(p) {
		if(dup) p->v = v;
		return p->v;
	}
	return NAN;
}

static inline double assignf(char const *s, double v) {
	return mapf(s, v, dup);
}

static inline double valuef(char const *s) {
	return mapf(s, 0, 0);
}

static char *enter(char const *prompt) {
	static char buf[256];
	fputs(prompt, stdout); fflush(stdout);
	fgets(buf, sizeof(buf), stdin);
	char *s = buf;
	for(; *s && !isgraph(*s); s++)
		;
	char *t = s + strlen(s);
	for(; (t > s) && !isgraph(*(t-1)); t--)
		;
	*t = '\0';
	return s;
}

int main(int argc, char **argv) {
	for(;;) {
		char const *name = enter("Enter: ");
		if(!*name) break;
		char *val = strchr(name, '=');
		if(val) {
			*val++ = '\0';
			assignf(name, strtod(val, NULL));
		} else {
			printf("%s = %F\n", name, valuef(name));
		}
	}
	return 0;
}
