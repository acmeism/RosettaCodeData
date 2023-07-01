#include <stdio.h>
#include <stdlib.h>

int icmp(const void *a, const void *b)
{
#define _I(x) *(const int*)x
	return _I(a) < _I(b) ? -1 : _I(a) > _I(b);
#undef _I
}

/* filter items in place and return number of uniques.  if a separate
   list is desired, duplicate it before calling this function */
int uniq(int *a, int len)
{
	int i, j;
	qsort(a, len, sizeof(int), icmp);
	for (i = j = 0; i < len; i++)
		if (a[i] != a[j]) a[++j] = a[i];
	return j + 1;
}

int main()
{
	int x[] = {1, 2, 1, 4, 5, 2, 15, 1, 3, 4};
	int i, len = uniq(x, sizeof(x) / sizeof(x[0]));
	for (i = 0; i < len; i++) printf("%d\n", x[i]);

	return 0;
}
