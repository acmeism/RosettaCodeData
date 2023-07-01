#include <stdio.h>
#include <stdlib.h>

typedef unsigned char byte;
int w = 0, h = 0, verbose = 0;
unsigned long count = 0;

byte **hor, **ver, **vis;
byte **c = 0;

enum { U = 1, D = 2, L = 4, R = 8 };

byte ** alloc2(int w, int h)
{
	int i;
	byte **x = calloc(1, sizeof(byte*) * h + h * w);
	x[0] = (byte *)&x[h];
	for (i = 1; i < h; i++)
		x[i] = x[i - 1] + w;
	return x;
}

void show()
{
	int i, j, v, last_v;
	printf("%ld\n", count);
#if 0
	for (i = 0; i <= h; i++) {
		for (j = 0; j <= w; j++)
			printf("%d ", hor[i][j]);
		puts("");
	}
	puts("");

	for (i = 0; i <= h; i++) {
		for (j = 0; j <= w; j++)
			printf("%d ", ver[i][j]);
		puts("");
	}
	puts("");
#endif
	for (i = 0; i < h; i++) {
		if (!i) v = last_v = 0;
		else last_v = v = hor[i][0] ? !last_v : last_v;

		for (j = 0; j < w; v = ver[i][++j] ? !v : v)
			printf(v ? "\033[31m[]" : "\033[33m{}");
		puts("\033[m");
	}
	putchar('\n');
}

void walk(int y, int x)
{
	if (x < 0 || y < 0 || x > w || y > h) return;

	if (!x || !y || x == w || y == h) {
		++count;
		if (verbose) show();
		return;
	}

	if (vis[y][x]) return;
	vis[y][x]++; vis[h - y][w - x]++;

	if (x && !hor[y][x - 1]) {
		hor[y][x - 1] = hor[h - y][w - x] = 1;
		walk(y, x - 1);
		hor[y][x - 1] = hor[h - y][w - x] = 0;
	}
	if (x < w && !hor[y][x]) {
		hor[y][x] = hor[h - y][w - x - 1] = 1;
		walk(y, x + 1);
		hor[y][x] = hor[h - y][w - x - 1] = 0;
	}

	if (y && !ver[y - 1][x]) {
		ver[y - 1][x] = ver[h - y][w - x] = 1;
		walk(y - 1, x);
		ver[y - 1][x] = ver[h - y][w - x] = 0;
	}

	if (y < h && !ver[y][x]) {
		ver[y][x] = ver[h - y - 1][w - x] = 1;
		walk(y + 1, x);
		ver[y][x] = ver[h - y - 1][w - x] = 0;
	}

	vis[y][x]--; vis[h - y][w - x]--;
}

void cut(void)
{
	if (1 & (h * w)) return;

	hor = alloc2(w + 1, h + 1);
	ver = alloc2(w + 1, h + 1);
	vis = alloc2(w + 1, h + 1);

	if (h & 1) {
		ver[h/2][w/2] = 1;
		walk(h / 2, w / 2);
	} else if (w & 1) {
		hor[h/2][w/2] = 1;
		walk(h / 2, w / 2);
	} else {
		vis[h/2][w/2] = 1;

		hor[h/2][w/2-1] = hor[h/2][w/2] = 1;
		walk(h / 2, w / 2 - 1);
		hor[h/2][w/2-1] = hor[h/2][w/2] = 0;

		ver[h/2 - 1][w/2] = ver[h/2][w/2] = 1;
		walk(h / 2 - 1, w/2);
	}
}

void cwalk(int y, int x, int d)
{
	if (!y || y == h || !x || x == w) {
		++count;
		return;
	}
	vis[y][x] = vis[h-y][w-x] = 1;

	if (x && !vis[y][x-1])
		cwalk(y, x - 1, d|1);
	if ((d&1) && x < w && !vis[y][x+1])
		cwalk(y, x + 1, d|1);
	if (y && !vis[y-1][x])
		cwalk(y - 1, x, d|2);
	if ((d&2) && y < h && !vis[y + 1][x])
		cwalk(y + 1, x, d|2);

	vis[y][x] = vis[h-y][w-x] = 0;
}

void count_only(void)
{
	int t;
	long res;
	if (h * w & 1) return;
	if (h & 1) t = h, h = w, w = t;

	vis = alloc2(w + 1, h + 1);
	vis[h/2][w/2] = 1;

	if (w & 1) vis[h/2][w/2 + 1] = 1;
	if (w > 1) {
		cwalk(h/2, w/2 - 1, 1);
		res = 2 * count - 1;
		count = 0;
		if (w != h)
			cwalk(h/2+1, w/2, (w & 1) ? 3 : 2);

		res += 2 * count - !(w & 1);
	} else {
		res = 1;
	}
	if (w == h) res = 2 * res + 2;
	count = res;
}

int main(int c, char **v)
{
	int i;

	for (i = 1; i < c; i++) {
		if (v[i][0] == '-' && v[i][1] == 'v' && !v[i][2]) {
			verbose = 1;
		} else if (!w) {
			w = atoi(v[i]);
			if (w <= 0) goto bail;
		} else if (!h) {
			h = atoi(v[i]);
			if (h <= 0) goto bail;
		} else
			goto bail;
	}
	if (!w) goto bail;
	if (!h) h = w;

	if (verbose) cut();
	else count_only();

	printf("Total: %ld\n", count);
	return 0;

bail:	fprintf(stderr, "bad args\n");
	return 1;
}
