#include <stdio.h>
#include <stdlib.h>

typedef unsigned int uint;
typedef unsigned long long tree;
#define B(x) (1ULL<<(x))

tree *list = 0;
uint cap = 0, len = 0;
uint offset[32] = {0, 1, 0};

void append(tree t)
{
	if (len == cap) {
		cap = cap ? cap*2 : 2;
		list = realloc(list, cap*sizeof(tree));
	}
	list[len++] = 1 | t<<1;
}

void show(tree t, uint len)
{
	for (; len--; t >>= 1)
		putchar(t&1 ? '(' : ')');
}

void listtrees(uint n)
{
	uint i;
	for (i = offset[n]; i < offset[n+1]; i++) {
		show(list[i], n*2);
		putchar('\n');
	}
}

/* assemble tree from subtrees
	n:   length of tree we want to make
	t:   assembled parts so far
	sl:  length of subtree we are looking at
	pos: offset of subtree we are looking at
	rem: remaining length to be put together
*/
void assemble(uint n, tree t, uint sl, uint pos, uint rem)
{
	if (!rem) {
		append(t);
		return;
	}

	if (sl > rem) // need smaller subtrees
		pos = offset[sl = rem];
	else if (pos >= offset[sl + 1]) {
		// used up sl-trees, try smaller ones
		if (!--sl) return;
		pos = offset[sl];
	}

	assemble(n, t<<(2*sl) | list[pos], sl, pos, rem - sl);
	assemble(n, t, sl, pos + 1, rem);
}

void mktrees(uint n)
{
	if (offset[n + 1]) return;
	if (n) mktrees(n - 1);

	assemble(n, 0, n-1, offset[n-1], n-1);
	offset[n+1] = len;
}

int main(int c, char**v)
{
	int n;
	if (c < 2 || (n = atoi(v[1])) <= 0 || n > 25) n = 5;

	// init 1-tree
	append(0);

	mktrees((uint)n);
	fprintf(stderr, "Number of %d-trees: %u\n", n, offset[n+1] - offset[n]);
	listtrees((uint)n);

	return 0;
}
