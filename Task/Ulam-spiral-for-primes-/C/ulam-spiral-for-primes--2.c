#include <stdio.h>
#include <stdlib.h>

int isprime(int n)
{
	int p;
	for (p = 2; p*p <= n; p++)
		if (n%p == 0) return 0;
	return n > 2;
}

int spiral(int w, int h, int x, int y)
{
	return y ? w + spiral(h - 1, w, y - 1, w - x - 1) : x;
}

int main(int c, char **v)
{
	int i, j, w = 50, h = 50, s = 1;
	if (c > 1 && (w = atoi(v[1])) <= 0) w = 50;
	if (c > 2 && (h = atoi(v[2])) <= 0) h = w;
	if (c > 3 && (s = atoi(v[3])) <= 0) s = 1;

	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++)
			putchar(isprime(w*h + s - 1 - spiral(w, h, j, i))[" #"]);
		putchar('\n');
	}
	return 0;
}
