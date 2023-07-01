#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct edit_s edit_t, *edit;
struct edit_s {
	char c1, c2;
	int n;
	edit next;
};

void leven(char *a, char *b)
{
	int i, j, la = strlen(a), lb = strlen(b);
	edit *tbl = malloc(sizeof(edit) * (1 + la));
	tbl[0] = calloc((1 + la) * (1 + lb), sizeof(edit_t));
	for (i = 1; i <= la; i++)
		tbl[i] = tbl[i-1] + (1+lb);

	for (i = la; i >= 0; i--) {
		char *aa = a + i;
		for (j = lb; j >= 0; j--) {
			char *bb = b + j;
			if (!*aa && !*bb) continue;

			edit e = &tbl[i][j];
			edit repl = &tbl[i+1][j+1];
			edit dela = &tbl[i+1][j];
			edit delb = &tbl[i][j+1];

			e->c1 = *aa;
			e->c2 = *bb;
			if (!*aa) {
				e->next = delb;
				e->n = e->next->n + 1;
				continue;
			}
			if (!*bb) {
				e->next = dela;
				e->n = e->next->n + 1;
				continue;
			}

			e->next = repl;
			if (*aa == *bb) {
				e->n = e->next->n;
				continue;
			}

			if (e->next->n > delb->n) {
				e->next = delb;
				e->c1 = 0;
			}
			if (e->next->n > dela->n) {
				e->next = dela;
				e->c1 = *aa;
				e->c2 = 0;
			}
			e->n = e->next->n + 1;
		}
	}

	edit p = tbl[0];
	printf("%s -> %s: %d edits\n", a, b, p->n);

	while (p->next) {
		if (p->c1 == p->c2)
			printf("%c", p->c1);
		else {
			putchar('(');
			if (p->c1) putchar(p->c1);
			putchar(',');
			if (p->c2) putchar(p->c2);
			putchar(')');
		}

		p = p->next;
	}
	putchar('\n');

	free(tbl[0]);
	free(tbl);
}

int main(void)
{
	leven("raisethysword", "rosettacode");
	return 0;
}
