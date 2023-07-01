#include <stdio.h>
#include <stdlib.h>

typedef unsigned int uint;
uint count = 0;

#define ulen sizeof(uint) * 8

/* could have defined as int solve(...), but void may have less
   chance to confuse poor optimizer */
void solve(int n)
{
	int cnt = 0;
	const uint full = -(int)(1 << (ulen - n));
	register uint bits, pos, *m, d, e;

	uint b0, b1, l[32], r[32], c[32], mm[33] = {0};
	n -= 3;
	/* require second queen to be left of the first queen, so
	   we ever only test half of the possible solutions. This
	   is why we can't handle n=1 here */
	for (b0 = 1U << (ulen - n - 3); b0; b0 <<= 1) {
		for (b1 = b0 << 2; b1; b1 <<= 1) {
			d = n;
			/* c: columns occupied by previous queens.
			   l: columns attacked by left diagonals
			   r: by right diagnoals */
			c[n] = b0 | b1;
			l[n] = (b0 << 2) | (b1 << 1);
			r[n] = (b0 >> 2) | (b1 >> 1);

			/* availabe columns on current row. m is stack */
			bits = *(m = mm + 1) = full & ~(l[n] | r[n] | c[n]);

			while (bits) {
				/* d: depth, aka row. counting backwards
				   because !d is often faster than d != n */
				while (d) {
					/* pos is right most nonzero bit */
					pos = -(int)bits & bits;

					/* mark bit used. only put current bits
					   on stack if not zero, so backtracking
					   will skip exhausted rows (because reading
					   stack variable is sloooow compared to
					   registers) */
					if ((bits &= ~pos))
						*m++ = bits | d;

					/* faster than l[d+1] = l[d]... */
					e = d--;
					l[d] = (l[e] | pos) << 1;
					r[d] = (r[e] | pos) >> 1;
					c[d] =  c[e] | pos;

					bits = full & ~(l[d] | r[d] | c[d]);

					if (!bits) break;
					if (!d) { cnt++; break; }
				}
				/* Bottom of stack m is a zero'd field acting
				   as sentinel.  When saving to stack, left
				   27 bits are the available columns, while
				   right 5 bits is the depth. Hence solution
				   is limited to size 27 board -- not that it
				   matters in foreseeable future. */
				d = (bits = *--m) & 31U;
				bits &= ~31U;
			}
		}
	}
	count = cnt * 2;
}

int main(int c, char **v)
{
	int nn;
	if (c <= 1 || (nn = atoi(v[1])) <= 0) nn = 8;

	if (nn > 27) {
		fprintf(stderr, "Value too large, abort\n");
		exit(1);
	}

	/* Can't solve size 1 board; might as well skip 2 and 3 */
	if (nn < 4) count = nn == 1;
	else	    solve(nn);

	printf("\nSolutions: %d\n", count);
	return 0;
}
