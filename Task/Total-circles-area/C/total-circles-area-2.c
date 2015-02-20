#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

typedef double flt;
typedef struct {
	flt x, y, r, r2;
	flt y0, y1;	// extent of circle y+r and y-r
	flt x0, x1;	// where scanline intersects circle
} circle_t;
#define SZ sizeof(circle_t)

circle_t circles[] = {
	{ 1.6417233788,  1.6121789534, 0.0848270516},
#error data snipped for space; copy from previous C example
};

flt max(flt x, flt y) { return x < y ? y : x; }
flt min(flt x, flt y) { return x > y ? y : x; }
flt sq(flt x) { return x * x; }
flt cdist(circle_t *c1, circle_t *c2) {
	return sqrt(sq(c1->x - c2->x) + sq(c1->y - c2->y));
}

inline void swap_c(circle_t *c)
{
	circle_t tmp = c[0];
	c[0] = c[1], c[1] = tmp;
}

flt area(circle_t *circs, int n_circ, flt ymin, flt ymax, flt step)
{
	int i, n = n_circ;

	circle_t *c = malloc(SZ * n);
	memcpy(c, circs, SZ * n);

	while (n--)
		for (i = 0; i < n; i++)
			if (c[i].y1 < c[i+1].y1) swap_c(c + i);

	flt total = 0;

	int row = 1 + ceil((ymax - ymin) / step);
	while (row--) {
		flt y = ymin + step * row;
		for (n = 0; n < n_circ; n++)
			if (y >= c[n].y1) // rest of circles below scanline, ignore
				break;
			else if (y > c[n].y0) {
				flt dx = sqrt(c[n].r2 - sq(y - c[n].y));
				c[n].x0 = c[n].x - dx;
				c[n].x1 = c[n].x + dx;

				// keep circles sorted by left intersection
				for (i = n; i-- && c[i].x0 > c[i+1].x0; swap_c(c + i));

			} else {// remove a circle when scanline has passed it
				memmove(c + n, c + n + 1, SZ * (--n_circ - n));
				n--;
			}

		if (!n) continue;

		flt right = c->x1;
		total += c->x1 - c->x0;

		for (i = 1; i < n; i++) {
			if (c[i].x1 <= right) continue;
			total += c[i].x1 - max(c[i].x0, right);
			right = c[i].x1;
		}
	}

	free(c);
	return total * step;
}

int main(void)
{
	int n_circ = sizeof(circles) / SZ;
	flt ymin = INFINITY, ymax = -INFINITY;

	circle_t *c1, *c2;
	for (c1 = circles + n_circ; c1-- > circles; ) {
		for (c2 = circles + n_circ; c2-- > circles; )
			// throw out circles inside another circle
			if (c1 != c2 && cdist(c1, c2) + c1->r <= c2->r) {
				*c1 = circles[--n_circ];
				break;
			}
		ymin = min(ymin, c1->y0 = c1->y - c1->r);
		ymax = max(ymax, c1->y1 = c1->y + c1->r);
		c1->r2 = sq(c1->r);
	}

	flt s = 1. / (1 << 20);
	flt y0 = floor(ymin / s) * s;
	flt a = area(circles, n_circ, y0, ymax, s);
	int nlines = (ymax - y0) / s;

	// roughly, it cease to make sense if sqrt(nlines) * 1e-14 >> s * s
	printf("area = %.10f\tat %d scanlines\n", a, nlines);

	return 0;
}
