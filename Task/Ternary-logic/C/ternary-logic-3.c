#include <stdio.h>
#include <stdlib.h>

typedef double half_truth, maybe;

inline maybe not3(maybe a) { return 1 - a; }

inline maybe
and3(maybe a, maybe b) { return a * b; }

inline maybe
or3(maybe a, maybe b) { return a + b - a * b; }

inline maybe
eq3(maybe a, maybe b) { return 1 - a - b + 2 * a * b; }

inline maybe
imply3(maybe a, maybe b) { return or3(not3(a), b); }

#define true3(x) ((x) * RAND_MAX > rand())
#define if3(x) if (true3(x))

int main()
{
	maybe roses_are_red = 0.25; /* they can be white or black, too */
	maybe violets_are_blue = 1; /* aren't they just */
	int i;

	puts("Verifying flowery truth for 40 times:\n");

	puts("Rose is NOT red:"); /* chance: .75 */
	for (i = 0; i < 40 || !puts("\n"); i++)
		printf( true3( not3(roses_are_red) ) ? "T" : "_");

	/* pick a rose and a violet; */
	puts("Rose is red AND violet is blue:");
	/* chance of rose being red AND violet being blue is .25 */
	for (i = 0; i < 40 || !puts("\n"); i++)
		printf( true3( and3(roses_are_red, violets_are_blue) )
			? "T" : "_");

	/* chance of rose being red OR violet being blue is 1 */
	puts("Rose is red OR violet is blue:");
	for (i = 0; i < 40 || !puts("\n"); i++)
		printf( true3( or3(roses_are_red, violets_are_blue) )
			? "T" : "_");

	/* pick two roses; chance of em being both red or both not red is .625 */
	puts("This rose is as red as that rose:");
	for (i = 0; i < 40 || !puts("\n"); i++)
		if3(eq3(roses_are_red, roses_are_red)) putchar('T');
		else putchar('_');

	return 0;
}
