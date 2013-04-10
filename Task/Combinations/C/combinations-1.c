#include <stdio.h>

/* Type marker stick: using bits to indicate what's chosen.  The stick can't
 * handle more than 32 items, but the idea is there; at worst, use array instead */
typedef unsigned long marker;
marker one = 1;

void comb(int pool, int need, marker chosen, int at)
{
	if (pool < need + at) return; /* not enough bits left */

	if (!need) {
		/* got all we needed; print the thing.  if other actions are
		 * desired, we could have passed in a callback function. */
		for (at = 0; at < pool; at++)
			if (chosen & (one << at)) printf("%d ", at);
		printf("\n");
		return;
	}
	/* if we choose the current item, "or" (|) the bit to mark it so. */
	comb(pool, need - 1, chosen | (one << at), at + 1);
	comb(pool, need, chosen, at + 1);  /* or don't choose it, go to next */
}

int main()
{
	comb(5, 3, 0, 0);
	return 0;
}
