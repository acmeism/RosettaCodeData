#include <stdio.h>

typedef unsigned char sint;
enum states { s_blnk = 0, s_tran, s_cont, s_disj };

/* Recursively look at each item in list, taking both choices of
   picking the item or not.  The state at each step depends on prvious
   pickings, with the state transition table:
	blank + no pick -> blank
	blank + pick -> contiguous
	transitional + no pick -> transitional
	transitional + pick -> disjoint
	contiguous + no pick -> transitional
	contiguous + pick -> contiguous
	disjoint + pick -> disjoint
	disjoint + no pick -> disjoint
   At first step, before looking at any item, state is blank.
   Because state is known at each step and needs not be calculated,
   it can be quite fast.
*/
unsigned char tbl[][2] = {
	{ s_blnk, s_cont },
	{ s_tran, s_disj },
	{ s_tran, s_cont },
	{ s_disj, s_disj },
};

void pick(sint n, sint step, sint state, char **v, unsigned long bits)
{
	int i, b;
	if (step == n) {
		if (state != s_disj) return;
		for (i = 0, b = 1; i < n; i++, b <<= 1)
			if ((b & bits)) printf("%s ", v[i]);
		putchar('\n');
		return;
	}

	bits <<= 1;
	pick(n, step + 1, tbl[state][0], v, bits); /* no pick */
	pick(n, step + 1, tbl[state][1], v, bits | 1); /* pick */
}

int main(int c, char **v)
{
	if (c - 1 >= sizeof(unsigned long) * 4)
		printf("Too many items");
	else
		pick(c - 1, 0, s_blnk, v + 1, 0);
	return 0;
}
