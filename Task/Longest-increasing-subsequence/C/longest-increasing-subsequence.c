#include <stdio.h>
#include <stdlib.h>

struct node {
	int val, len;
	struct node *next;
};

void lis(int *v, int len)
{
	int i;
	struct node *p, *n = calloc(len, sizeof *n);
	for (i = 0; i < len; i++)
		n[i].val = v[i];

	for (i = len; i--; ) {
		// find longest chain that can follow n[i]
		for (p = n + i; p++ < n + len; ) {
			if (p->val > n[i].val && p->len >= n[i].len) {
				n[i].next = p;
				n[i].len = p->len + 1;
			}
		}
	}

	// find longest chain
	for (i = 0, p = n; i < len; i++)
		if (n[i].len > p->len) p = n + i;

	do printf(" %d", p->val); while ((p = p->next));
	putchar('\n');

	free(n);
}

int main(void)
{
	int x[] = { 3, 2, 6, 4, 5, 1 };
	int y[] = { 0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15 };

	lis(x, sizeof(x) / sizeof(int));
	lis(y, sizeof(y) / sizeof(int));
	return 0;
}
