#include <stdio.h>
#include <stdlib.h>

/* select the k-th smallest item in array x of length len */
int qselect(int *x, int k, int len)
{
	inline void swap(int a, int b) {
		int t = x[a];
		x[a] = x[b], x[b] = t;
	}

	int left = 0, right = len - 1;
	int pivot, pos, i;

	while (left < right) {
		pivot = x[k];
		swap(k, right);
		for (i = pos = left; i < right; i++) {
			if (x[i] < pivot) {
				swap(i, pos);
				pos++;
			}
		}
		swap(right, pos);
		if (pos == k) break;
		if (pos < k) left = pos + 1;
		else right = pos - 1;
	}
	return x[k];
}

#define N 10000001

int icmp(const void *a, const void *b)
{
	return *(int*)a < *(int*)b ? -1 : *(int*)a > *(int*) b;
}

int main()
{
	int i, med, *x = malloc(sizeof(int) * N);

	/* divide by large value to create many duplicate values */
	for (i = 0; i < N; i++) x[i] = rand()/100000;

	med = qselect(x, N/2, N);

	/* qsort for speed comparison */
	//qsort(x, N, sizeof(int), icmp); med = x[N/2];

	printf("median is %d\n", med);

	/* just to show it is the median */
	int less = 0, more = 0, eq = 0;
	for (i = 0; i < N; i++) {
		if	(x[i] < med) less ++;
		else if (x[i] > med) more ++;
		else eq ++;
	}
	printf("<: %d\n>: %d\n=: %d\n", less, more, eq);

	return 0;
}
