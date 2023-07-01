#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef unsigned char byte;
byte *grid = 0;

int w, h, len;
unsigned long long cnt;

static int next[4], dir[4][2] = {{0, -1}, {-1, 0}, {0, 1}, {1, 0}};
void walk(int y, int x)
{
	int i, t;

	if (!y || y == h || !x || x == w) {
		cnt += 2;
		return;
	}

	t = y * (w + 1) + x;
	grid[t]++, grid[len - t]++;

	for (i = 0; i < 4; i++)
		if (!grid[t + next[i]])
			walk(y + dir[i][0], x + dir[i][1]);

	grid[t]--, grid[len - t]--;
}

unsigned long long solve(int hh, int ww, int recur)
{
	int t, cx, cy, x;

	h = hh, w = ww;

	if (h & 1) t = w, w = h, h = t;
	if (h & 1) return 0;
	if (w == 1) return 1;
	if (w == 2) return h;
	if (h == 2) return w;

	cy = h / 2, cx = w / 2;

	len = (h + 1) * (w + 1);
	grid = realloc(grid, len);
	memset(grid, 0, len--);

	next[0] = -1;
	next[1] = -w - 1;
	next[2] = 1;
	next[3] = w + 1;

	if (recur) cnt = 0;
	for (x = cx + 1; x < w; x++) {
		t = cy * (w + 1) + x;
		grid[t] = 1;
		grid[len - t] = 1;
		walk(cy - 1, x);
	}
	cnt++;

	if (h == w)
		cnt *= 2;
	else if (!(w & 1) && recur)
		solve(w, h, 0);

	return cnt;
}

int main()
{
	int y, x;
	for (y = 1; y <= 10; y++)
		for (x = 1; x <= y; x++)
			if (!(x & 1) || !(y & 1))
				printf("%d x %d: %llu\n", y, x, solve(y, x, 1));

	return 0;
}
