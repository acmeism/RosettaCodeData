#include <stdio.h>
#include <stdlib.h>

int *map, w, ww;

void make_map(double p)
{
	int i, thresh = RAND_MAX * p;
	i = ww = w * w;

	map = realloc(map, i * sizeof(int));
	while (i--) map[i] = -(rand() < thresh);
}

char alpha[] = "+.ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		"abcdefghijklmnopqrstuvwxyz";
#define ALEN ((int)(sizeof(alpha) - 3))

void show_cluster(void)
{
	int i, j, *s = map;

	for (i = 0; i < w; i++) {
		for (j = 0; j < w; j++, s++)
			printf(" %c", *s < ALEN ? alpha[1 + *s] : '?');
		putchar('\n');
	}
}

void recur(int x, int v) {
	if (x >= 0 && x < ww && map[x] == -1) {
		map[x] = v;
		recur(x - w, v);
		recur(x - 1, v);
		recur(x + 1, v);
		recur(x + w, v);
	}
}

int count_clusters(void)
{
	int i, cls;

	for (cls = i = 0; i < ww; i++) {
		if (-1 != map[i]) continue;
		recur(i, ++cls);
	}

	return cls;
}

double tests(int n, double p)
{
	int i;
	double k;

	for (k = i = 0; i < n; i++) {
		make_map(p);
		k += (double)count_clusters() / ww;
	}
	return k / n;
}

int main(void)
{
	w = 15;
	make_map(.5);
	printf("width=15, p=0.5, %d clusters:\n", count_clusters());
	show_cluster();

	printf("\np=0.5, iter=5:\n");
	for (w = 1<<2; w <= 1<<14; w<<=2)
		printf("%5d %9.6f\n", w, tests(5, .5));

	free(map);
	return 0;
}
