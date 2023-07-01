#include <stdio.h>

int circle_sort_inner(int *start, int *end)
{
	int *p, *q, t, swapped;

	if (start == end) return 0;

	// funny "||" on next line is for the center element of odd-lengthed array
	for (swapped = 0, p = start, q = end; p<q || (p==q && ++q); p++, q--)
		if (*p > *q)
			t = *p, *p = *q, *q = t, swapped = 1;

	// q == p-1 at this point
	return swapped | circle_sort_inner(start, q) | circle_sort_inner(p, end);
}

//helper function to show arrays before each call
void circle_sort(int *x, int n)
{
	do {
		int i;
		for (i = 0; i < n; i++) printf("%d ", x[i]);
		putchar('\n');
	} while (circle_sort_inner(x, x + (n - 1)));
}

int main(void)
{
	int x[] = {5, -1, 101, -4, 0, 1, 8, 6, 2, 3};
	circle_sort(x, sizeof(x) / sizeof(*x));

	return 0;
}
