#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <float.h>
#include <fenv.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

static intmax_t gcd(intmax_t a, intmax_t b) {
	// https://en.wikipedia.org/wiki/Greatest_common_divisor#Binary_GCD_algorithm
	// - brute force it for now
	int d = 0;
	for(; !((a | b) & 1); a /= 2, b /= 2, d++)
		;
	for(; !(a & 1); a /= 2)
		;
	for(; !(b & 1); b /= 2)
		;
	while(a != b) {
		if(a > b) {
			for(a = a - b; !(a & 1); a /= 2)
				;
		} else {
			for(b = b - a; !(b & 1); b /= 2)
				;
		}
	}
	return ((intmax_t)1 << d) * a;
}

typedef struct {
	intmax_t n;
	intmax_t d;
}	rational_t;

static int ratprint(rational_t a) {
	if(a.d == 1) return printf("%jd", a.n);
	intmax_t sign = (a.n < 0) ? -1 : 1;
	intmax_t n = sign * a.n;
	if(n > a.d) return printf("%jd:%jd/%jd", a.n / a.d, n % a.d, a.d);
	if(n < a.d) return printf("%jd/%jd", a.n, a.d);
	return printf("%jd", sign);
}

static int ratdecprint(rational_t a) {
	char   t[(DBL_DIG * 2) + 4];
	double f = (double)a.n / a.d;
	// use extra digit to prevent rounding disabling reccurence detection
	int    n = sprintf(t, "%#.*f", DBL_DIG+1, f);
	t[n--] = '\0';
	for(; (n > 0) && (t[n-1] == '0') && (t[n-2] != '.'); n--)
		;
	t[n] = '\0';
	char *s = strchr(t, '.') + 1;
	int   u = n - (s - t);
	for(int w = 1; w <= (u / 2); w++) {
		int m = u - (2 * w);
		for(int o = 0; o < m; o++) {
			if(memcmp(s+o, s+o+w, u-o-w) == 0) {
				if((w == 1) && (s[o] == '9')) {
					// recurring 9s - allow sprintf to do rounding
					n = sprintf(t, "%#.*f", DBL_DIG, f);
					t[n--] = '\0';
					for(; (n > 0) && (t[n-1] == '0') && (t[n-2] != '.'); n--)
						;
					t[n] = '\0';
					goto done;
				}
				memmove(s+o+1, s+o, w);
				s[o] = '(';
				s[o+1+w] = ')';
				s[o+1+w+1] = '\0';
				goto done;
			}
		}
	}
done:
	return printf("%s", t);
}

static rational_t rational(intmax_t n, intmax_t d) {
	if(n != 0) {
		intmax_t g = gcd((n < 0) ? -n : n, d);
		return (rational_t){ .n = n / g, .d = d / g };
	}
	return (rational_t){ .n = 0, .d = 1 };
}

static rational_t ratreciprocal(rational_t a) {
	intmax_t s = (a.n < 0) ? -1 : 1;
	return rational(s * a.d, s * a.n);
}

static inline void ratequalize(rational_t *a, rational_t *b) {
	if(a->d != b->d) {
		intmax_t d = a->d * b->d;
		a->n *= b->d;
		b->n *= a->d;
		a->d = b->d = d;
	}
}

static inline rational_t strtor(char const *cs, char **endp) {
	char    *s, *t = NULL;
	intmax_t u = 0;
	intmax_t n = strtoimax(cs, &s, 10);
	intmax_t d = 1;
	int      c = *s;
	if((c == '.') || (c == ':')) {
		u = n;
		n = strtoimax((t = s+1), &s, 10);
		if(c == ':') {
			if(*s == '/') {
				d = strtoimax(s+1, &s, 10);
			}
		} else {
			// decimal fraction
			// - brute force it for now
			for(; t < s; t++, d *= 10)
				;
		}
	}
	if(endp) *endp = s;
	return rational((u * d) + n, d);
}

static rational_t ratneg(rational_t a) {
	return rational(-a.n, a.d);
}

static rational_t ratabs(rational_t a) {
	return rational(((a.n < 0) ? -a.n : a.n), a.d);
}

static rational_t ratadd(rational_t a, rational_t b) {
	ratequalize(&a, &b);
	return rational(a.n + b.n, a.d);
}

static rational_t ratsub(rational_t a, rational_t b) {
	ratequalize(&a, &b);
	return rational(a.n - b.n, a.d);
}

static rational_t ratmul(rational_t a, rational_t b) {
	return rational(a.n * b.n, a.d * b.d);
}

static rational_t ratdiv(rational_t a, rational_t b) {
	return ratmul(a, ratreciprocal(b));
}

static rational_t result = { 0, 1 };

enum { ADDITIVE, MULTIPLICATIVE, UNARY };

static rational_t rateval(char *s, char **endp, int pri) {
#define rateval(s,endp,...)  (rateval)((s),(endp),(__VA_ARGS__+0))
	rational_t u, v;
	if(pri < UNARY) {
		u = rateval(s, &s, pri+1);
	}
	for(int o; (o = *s); ) {
		if(!isgraph(o)) {
			s++;
			continue;
		}
		if(o == ')') {
			s++;
			break;
		}
		switch(pri) {
		case UNARY:
			u =
				!strncmp(s, "abs", 3) ? ratabs(rateval(s+3, &s, pri)) :
				(o == '-')            ? ratneg(rateval(s+1, &s, pri)) :
				(o == '+')            ? rateval(s+1, &s, pri) :
				(o == '(')            ? rateval(s+1, &s) :
				(o == '@')            ? s++, result :
				/**/                    strtor(s, &s);
			break;
		case MULTIPLICATIVE:
			switch(o) {
			case 'x': case '*':
				v = rateval(s+1, &s, pri+1);
				u = ratmul(u, v);
				continue;
			case '/':
				v = rateval(s+1, &s, pri+1);
				u = ratdiv(u, v);
				continue;
			}
			break;
		case ADDITIVE:
			switch(o) {
			case '+':
				v = rateval(s+1, &s, pri+1);
				u = ratadd(u, v);
				continue;
			case '-':
				v = rateval(s+1, &s, pri+1);
				u = ratsub(u, v);
				continue;
			}
			break;
		}
		break;
	}
	if(endp) *endp = s;
	return u;
}

static void ratep(char *s) {
	result = rateval(s, &s);
	putchar('=');
	putchar(' ');
	ratprint(result);
	putchar('\n');
	putchar('=');
	putchar(' ');
	ratdecprint(result);
	putchar('\n');
}

static void ratrepl(void) {
	for(char line[256];
		(putchar('>'), putchar(' '), fflush(stdout), fgets(line, sizeof(line), stdin));
	) {
		char *s = line, *t;
		for(; *s && !isgraph(*s); s++)
			;
		for(t = s; *t && isprint(*t); t++)
			;
		if(*t) {
			*t = '\0';
		}
		if((strcmp(s, "q") == 0) || (strcmp(s, "quit") == 0)) break;
		ratep(s);
	}
}

int main(int argc, char **argv) {
	if(argc > 1) for(int argi = 1; argi < argc; argi++) {
		ratep(argv[argi]);
	} else {
		ratrepl();
	}
	return 0;
}

