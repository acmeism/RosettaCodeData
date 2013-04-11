#include <stdio.h>
#include <stdlib.h>
#include <string.h>

inline
void merge(int *left, int l_len, int *right, int r_len, int *out)
{
	int i, j, k;
	for (i = j = k = 0; i < l_len && j < r_len; )
		out[k++] = left[i] < right[j] ? left[i++] : right[j++];

	while (i < l_len) out[k++] = left[i++];
	while (j < r_len) out[k++] = right[j++];
}

/* inner recursion of merge sort */
void recur(int *buf, int *tmp, int len)
{
	int l = len / 2;
	if (len <= 1) return;

	/* note that buf and tmp are swapped */
	recur(tmp, buf, l);
	recur(tmp + l, buf + l, len - l);

	merge(tmp, l, tmp + l, len - l, buf);
}

/* preparation work before recursion */
void merge_sort(int *buf, int len)
{
	/* call alloc, copy and free only once */
	int *tmp = malloc(sizeof(int) * len);
	memcpy(tmp, buf, sizeof(int) * len);

	recur(buf, tmp, len);

	free(tmp);
}

int main()
{
#	define LEN 20
	int i, x[LEN];

	for (i = 0; i < LEN; i++)
		x[i] = rand() % LEN;

	puts("before sort:");
	for (i = 0; i < LEN; i++) printf("%d ", x[i]);
	putchar('\n');

	merge_sort(x, LEN);

	puts("after sort:");
	for (i = 0; i < LEN; i++) printf("%d ", x[i]);
	putchar('\n');

	return 0;
}
