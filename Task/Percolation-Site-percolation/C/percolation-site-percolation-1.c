#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *cell, *start, *end;
int m, n;

void make_grid(int x, int y, double p)
{
	int i, j, thresh = p * RAND_MAX;

	m = x, n = y;
	end = start = realloc(start, (x+1) * (y+1) + 1);

	memset(start, 0, m + 1);

	cell = end = start + m + 1;
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++)
			*end++ = rand() < thresh ? '+' : '.';
		*end++ = '\n';
	}

	end[-1] = 0;
	end -= ++m; // end is the first cell of bottom row
}

int ff(char *p) // flood fill
{
	if (*p != '+') return 0;

	*p = '#';
	return p >= end || ff(p+m) || ff(p+1) || ff(p-1) || ff(p-m);
}

int percolate(void)
{
	int i;
	for (i = 0; i < m && !ff(cell + i); i++);
	return i < m;
}

int main(void)
{
	make_grid(15, 15, .5);
	percolate();

	puts("15x15 grid:");
	puts(cell);

	puts("\nrunning 10,000 tests for each case:");

	double p;
	int ip, i, cnt;
	for (ip = 0; ip <= 10; ip++) {
		p = ip / 10.;
		for (cnt = i = 0; i < 10000; i++) {
			make_grid(15, 15, p);
			cnt += percolate();
		}
		printf("p=%.1f:  %.4f\n", p, cnt / 10000.);
	}

	return 0;
}
