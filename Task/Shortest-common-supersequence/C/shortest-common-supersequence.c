#include <stdio.h>
#include <string.h>

typedef struct link link_t;
struct link {
	int len;
	char letter;
	link_t *next;
};

// Stores a copy of a SCS of x and y in out.  Caller needs to make sure out is long enough.
int scs(char *x, char *y, char *out)
{
	int lx = strlen(x), ly = strlen(y);
	link_t lnk[ly + 1][lx + 1];
	
	for (int i = 0; i < ly; i++)
		lnk[i][lx] = (link_t) {ly - i, y[i], &lnk[i + 1][lx]};

	for (int j = 0; j < lx; j++)
		lnk[ly][j] = (link_t) {lx - j, x[j], &lnk[ly][j + 1]};

	lnk[ly][lx] = (link_t) {0};

	for (int i = ly; i--; ) {
		for (int j = lx; j--; ) {
			link_t *lp = &lnk[i][j];
			if (y[i] == x[j]) {
				lp->next = &lnk[i+1][j+1];
				lp->letter = x[j];
			} else if (lnk[i][j+1].len < lnk[i+1][j].len) {
				lp->next = &lnk[i][j+1];
				lp->letter = x[j];
			} else {
				lp->next = &lnk[i+1][j];
				lp->letter = y[i];
			}
			lp->len = lp->next->len + 1;
		}
	}

	for (link_t *lp = &lnk[0][0]; lp; lp = lp->next)
		*out++ = lp->letter;

	return 0;
}

int main(void)
{
	char x[] = "abcbdab", y[] = "bdcaba", res[128];
	scs(x, y, res);
	printf("SCS(%s, %s) -> %s\n", x, y, res);
	return 0;
}
