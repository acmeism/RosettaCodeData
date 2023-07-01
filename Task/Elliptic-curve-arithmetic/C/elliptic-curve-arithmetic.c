#include <stdio.h>
#include <math.h>

#define C 7
typedef struct { double x, y; } pt;

pt zero(void) { return (pt){ INFINITY, INFINITY }; }

// should be INFINITY, but numeric precision is very much in the way
int is_zero(pt p) { return p.x > 1e20 || p.x < -1e20; }

pt neg(pt p) { return (pt){ p.x, -p.y }; }

pt dbl(pt p) {
	if (is_zero(p)) return p;

	pt r;
	double L = (3 * p.x * p.x) / (2 * p.y);
	r.x = L * L - 2 * p.x;
	r.y = L * (p.x - r.x) - p.y;
	return r;
}

pt add(pt p, pt q) {
	if (p.x == q.x && p.y == q.y) return dbl(p);
	if (is_zero(p)) return q;
	if (is_zero(q)) return p;

	pt r;
	double L = (q.y - p.y) / (q.x - p.x);
	r.x = L * L - p.x - q.x;
	r.y = L * (p.x - r.x) - p.y;
	return r;
}

pt mul(pt p, int n) {
	int i;
	pt r = zero();

	for (i = 1; i <= n; i <<= 1) {
		if (i & n) r = add(r, p);
		p = dbl(p);
	}
	return r;
}

void show(const char *s, pt p) {
	printf("%s", s);
	printf(is_zero(p) ? "Zero\n" : "(%.3f, %.3f)\n", p.x, p.y);
}

pt from_y(double y) {
	pt r;
	r.x = pow(y * y - C, 1.0/3);
	r.y = y;
	return r;
}

int main(void) {
	pt a, b, c, d;

	a = from_y(1);
	b = from_y(2);

	show("a = ", a);
	show("b = ", b);
	show("c = a + b = ", c = add(a, b));
	show("d = -c = ", d = neg(c));
	show("c + d = ", add(c, d));
	show("a + b + d = ", add(a, add(b, d)));
	show("a * 12345 = ", mul(a, 12345));

	return 0;
}
