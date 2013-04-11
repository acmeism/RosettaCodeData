#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>

#define die(msg) fprintf(stderr, msg"\n"), abort();
double get(const char *s, const char *e, char **new_e)
{
	const char *t;
	double a, b;

	for (e--; e >= s && isspace(*e); e--);
	for (t = e; t > s && !isspace(t[-1]); t--);

	if (t < s) die("underflow");

#define get2(expr) b = get(s, t, (char **)&t), a = get(s, t, (char **)&t), a = expr
	a = strtod(t, (char **)&e);
	if (e <= t) {
		if	(t[0] == '+') get2(a + b);
		else if (t[0] == '-') get2(a - b);
		else if (t[0] == '*') get2(a * b);
		else if (t[0] == '/') get2(a / b);
		else if (t[0] == '^') get2(pow(a, b));
		else {
			fprintf(stderr, "'%c': ", t[0]);
			die("unknown token");
		}
	}
#undef get2

	*(const char **)new_e = t;
	return a;
}

double rpn(const char *s)
{
	const char *e = s + strlen(s);
	double v = get(s, e, (char**)&e);

	while (e > s && isspace(e[-1])) e--;
	if (e == s) return v;

	fprintf(stderr, "\"%.*s\": ", e - s, s);
	die("front garbage");
}

int main(void)
{
	printf("%g\n", rpn("3 4 2 * 1 5 - 2 3 ^ ^ / +"));
	return 0;
}
