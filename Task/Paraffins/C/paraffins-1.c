#include <stdio.h>

#define MAX_N 33	/* max number of tree nodes */
#define BRANCH 4	/* max number of edges a single node can have */

/* The basic idea: a paraffin molecule can be thought as a simple tree
   with each node being a carbon atom.  Counting molecules is thus the
   problem of counting free (unrooted) trees of given number of nodes.

   An unrooted tree needs to be uniquely represented, so we need a way
   to cannonicalize equivalent free trees.  For that, we need to first
   define the cannonical form of rooted trees.  Since rooted trees can
   be constructed by a root node and up to BRANCH rooted subtrees that
   are arranged in some definite order, we can define it thusly:
     * Given the root of a tree, the weight of each of its branches is
       the number of nodes contained in that branch;
     * A cannonical rooted tree would have its direct subtrees ordered
       in descending order by weight;
     * In case multiple subtrees are the same weight, they are ordered
       by some unstated, but definite, order (this code doesn't really
       care what the ordering is; it only counts the number of choices
       in such a case, not enumerating individual trees.)

   A rooted tree of N nodes can then be constructed by adding smaller,
   cannonical rooted trees to a root node, such that:
     * Each subtree has fewer than BRANCH branches (since it must have
       an empty slot for an edge to connect to the new root);
     * Weight of those subtrees added later are no higher than earlier
       ones;
     * Their weight total N-1.
   A rooted tree so constructed would be itself cannonical.

   For an unrooted tree, we can define the radius of any of its nodes:
   it's the maximum weight of any of the subtrees if this node is used
   as the root.  A node is the center of a tree if it has the smallest
   radius among all the nodes.  A tree can have either one or two such
   centers; if two, they must be adjacent (cf. Knuth, tAoCP 2.3.4.4).

   An important fact is that, a node in a tree is its sole center, IFF
   its radius times 2 is no greater than the sum of the weights of all
   branches (ibid).  While we are making rooted trees, we can add such
   trees encountered to the count of cannonical unrooted trees.

   A bi-centered unrooted tree with N nodes can be made by joining two
   trees, each with N/2 nodes and fewer than BRANCH subtrees, at root.
   The pair must be ordered in aforementioned implicit way so that the
   product is cannonical. */

typedef unsigned long long xint;
#define FMT "llu"

xint rooted[MAX_N] = {1, 1, 0};
xint unrooted[MAX_N] = {1, 1, 0};

/* choose k out of m possible values; chosen values may repeat, but the
   ordering of them does not matter.  It's binomial(m + k - 1, k) */
xint choose(xint m, xint k)
{
	xint i, r;

	if (k == 1) return m;
	for (r = m, i = 1; i < k; i++)
		r = r * (m + i) / (i + 1);
	return r;
}

/* constructing rooted trees of BR branches at root, with at most
   N radius, and SUM nodes in the partial tree already built. It's
   recursive, and CNT and L carry down the number of combinations
   and the tree radius already encountered. */
void tree(xint br, xint n, xint cnt, xint sum, xint l)
{
	xint b, c, m, s;

	for (b = br + 1; b <= BRANCH; b++) {
		s = sum + (b - br) * n;
		if (s >= MAX_N) return;

		/* First B of BR branches are all of weight n; the
		   rest are at most of weight N-1 */
		c = choose(rooted[n], b - br) * cnt;

		/* This partial tree is singly centered as is */
		if (l * 2 < s) unrooted[s] += c;

		/* Trees saturate at root can't be used as building
		   blocks for larger trees, so forget them */
		if (b == BRANCH) return;
		rooted[s] += c;

		/* Build the rest of the branches */
		for (m = n; --m; ) tree(b, m, c, s, l);
	}
}

void bicenter(int s)
{
	if (s & 1) return;

	/* Pick two of the half-size building blocks, allowing
	   repetition. */
	unrooted[s] += rooted[s/2] * (rooted[s/2] + 1) / 2;
}

int main()
{
	xint n;
	for (n = 1; n < MAX_N; n++) {
		tree(0, n, 1, 1, n);
		bicenter(n);
		printf("%"FMT": %"FMT"\n", n, unrooted[n]);
	}

	return 0;
}
