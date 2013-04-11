#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CW 10	/* cell width. This decides how big the output is */

typedef struct cell_t cell_t, *cell;

enum { N, E, S, W, V };
struct cell_t {
	unsigned int flags;
	cell prev, next, nei[4]; /* neighbors */
};

int sx, sy, sz, w, h;

#define C(y, x) c[(y) * w + x]
#define P(y, x) pix[(y) * w2 + x]
void draw_maze(cell *c)
{
#define FOR(a, b) for(a = 0; a < b; a++)
	FILE *fp;
	int w2 = w * CW + 8, h2 = h * CW + 7;
	char *pix = malloc(w2 * h2);
	memset(pix, 200, w2 * h2);

	void draw_face(int x, int y, int ww, int hh, int px, int py) {
		int i, j, k, l;
		cell t;

		px += 2, py += 2;
		for (i = py; i <= py + hh * CW; i++)
			memset(&P(i, px), 0, ww * CW+1);

		px++, py++;
#		define mark(y, x) P(py + CW*i + y, px + CW*j + x) = 255
		FOR (i, hh) FOR (j, ww) {
			FOR(k, CW - 1) FOR(l, CW - 1) mark(k, l);

			t = C(y + i, x + j);
			if (t->flags & (1 << N))
				FOR (l, CW - 1) mark(-1, l);
			if (t->flags & (1 << S))
				FOR (l, CW - 1) mark(CW - 1, l);
			if (t->flags & (1 << E))
				FOR (l, CW - 1) mark(l, CW - 1);
			if (t->flags & (1 << W))
				FOR (l, CW - 1) mark(l, -1);
		}
	}

	draw_face(0, 0, sx, sy, 0, 0);
	draw_face(0, sy, sx, sz, 0, CW*sy + 1);
	draw_face(sx, sy, sy, sz, CW*sx + 1, CW*sy + 1);
	draw_face(sx + sy, sy, sx, sz, CW*(sx + sy) + 2, CW*sy + 1);
	draw_face(sx + sy + sx, sy, sy, sz, CW*(sx + sy + sx) + 3, CW*sy + 1);
	draw_face(sx + sy, sy + sz, sx, sy, CW*(sx + sy) + 2, CW*(sy + sz) + 2);

	fp = fopen("maze.pgm", "w+");
	fprintf(fp, "P5\n%d %d\n255\n", w2, h2);
	fwrite(pix, 1, w2 * h2, fp);
	fclose(fp);
}

cell rand_neighbor(cell x)
{
	cell r = 0;
	int i, c = 1;
	for (i = N; i <= W; i++) {
		if (!x->nei[i] || (x->nei[i]->flags & (1 << V)))
			continue;
		if (rand() % c++ == 0)
			r = x->nei[i];
	}
	return r;
}

void link_cells(cell a, cell b)
{
	int i;
	for (i = N; i <= W; i++) {
		if (a->nei[i] != b) continue;
		a->flags |= 1 << i;
		break;
	}
	for (i = N; i <= W; i++) {
		if (b->nei[i] != a) continue;
		b->flags |= 1 << i;
		break;
	}
}

void walk(cell head)
{
	cell tail = head, p, n;

	while (head) {
		for (p = head; p; p = n) {
			p->flags |= 1 << V;
			n = rand_neighbor(p);
			if (!n) break;
			tail->next = n;
			n->prev = tail;

			tail = n;
			link_cells(p, n);
		}
		while (head && !rand_neighbor(head)) head = head->next;
	}
}

void make_maze(void)
{
	int i, j;
	int n = (sx * sy + sx * sz + sy * sz) * 2;
	cell t, *c;
	cell_t * cells;

	w = 2 * sx + 2 * sy, h = sy * 2 + sz;
	cells = calloc(sizeof(cell_t), n);
	c = calloc(sizeof(cell), w * h);

	for (i = 0; i < sy; i++)
		for (j = 0; j < sx; j++)
			C(i, j) = cells + --n;
	for (; i < sy + sz; i++)
		for (j = 0; j < w; j++)
			C(i, j) = cells + --n;
	for (; i < h; i++)
		for (j = sx + sy; j < w - sy; j++)
			C(i, j) = cells + --n;

	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++) {
			t = C(i, j);
			if (!t) continue;
			if (i) t->nei[N] = C(i - 1, j);
			if (i < h - 1) t->nei[S] = C(i + 1, j);
			if (j) t->nei[W] = C(i, j - 1);
			if (j < w - 1) t->nei[E] = C(i, j + 1);
		}
	}

	for (j = 0; j < sx; j++) {
		C(0, j)->nei[N] = C(sy, w - sy - j - 1);
		C(sy, w - sy - j - 1)->nei[N] = C(0, j);

		C(h - sy - 1, j)->nei[S] = C(h - 1, w - sy - j - 1);
		C(h - 1, w - sy - j - 1)->nei[S] = C(h - sy - 1, j);
	}

	for (i = sy; i < sy + sz; i++) {
		C(i, 0)->nei[W] = C(i, w - 1);
		C(i, w - 1)->nei[E] = C(i, 0);
	}

	for (i = 0; i < sy; i++) {
		C(i, 0)->nei[W] = C(sy, w - sy + i);
		C(sy, w - sy + i)->nei[N] = C(i, 0);

		C(i, sx - 1)->nei[E] = C(sy, sx + sy - i - 1);
		C(sy, sx + sy - i - 1)->nei[N] = C(i, sx - 1);

		C(h - sy - 1, sx + i)->nei[S] = C(h - 1 - i, sx + sy);
		C(h - 1 - i, sx + sy)->nei[W] = C(h - sy - 1, sx + i);

		C(sy + sz + i, w - sy - 1)->nei[E] = C(sy + sz - 1, w - sy + i);
		C(sy + sz - 1, w - sy + i)->nei[S] = C(sy + sz + i, w - sy - 1);
	}

	walk(C(0, 0));
	draw_maze(c);
}

int main(int c, char **v)
{
	if (c < 2 || (sx = atoi(v[1])) <= 0) sx = 10;
	if (c < 3 || (sy = atoi(v[2])) <= 0) sy = sx;
	if (c < 4 || (sz = atoi(v[3])) <= 0) sz = sy;

	make_maze();

	return 0;
}
