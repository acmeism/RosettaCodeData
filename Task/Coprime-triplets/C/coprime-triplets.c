/*
************************
*                      *
*   COPRIME TRIPLETS   *
*                      *
************************
*/
/* Starting from the sequence a(1)=1 and a(2)=2 find the next smallest number
which is coprime to the last two predecessors and has not yet appeared in the
sequence.
p and q are coprimes if they have no common factors other than 1.
Let p, q < 50 */

#include <stdio.h>

int Gcd(int v1, int v2)
{
	/* It evaluates the Greatest Common Divisor between v1 and v2 */
	int a, b, r;
	if (v1 < v2)
	{
		a = v2;
		b = v1;
	}
	else
	{
		a = v1;
		b = v2;
	}
	do
	{
		r = a % b;
		if (r == 0)
		{
			break;
		}
		else
		{
			a = b;
			b = r;
		}
	} while (1 == 1);
	return b;
}

int NotInList(int num, int numtrip, int *tripletslist)
{
	/* It indicates if the value num is already present in the list tripletslist of length numtrip */
	for (int i = 0; i < numtrip; i++)
	{
		if (num == tripletslist[i])
		{
			return 0;
		}
	}
	return 1;
} 	

int main()
{
	int coprime[50];
	int gcd1, gcd2;
	int ntrip = 2;
	int n = 3;
	
	/* The first two values */
	coprime[0] = 1;
	coprime[1] = 2;

	while ( n < 50)
	{
		gcd1 = Gcd(n, coprime[ntrip-1]);
		gcd2 = Gcd(n, coprime[ntrip-2]);
		/* if n is coprime of the previous two value
		and it isn't already present in the list */
		if (gcd1 == 1 && gcd2 == 1 && NotInList(n, ntrip, coprime))
		{
			coprime[ntrip++] = n;
			/* It starts searching a new triplets */
			n = 3;
		}
		else
		{
			/* Trying to find a triplet with the next value */
			n++;
		}
	}
	
	/* printing the list of coprime triplets */
	printf("\n");
	for (int i = 0; i < ntrip; i++)
	{
		printf("%2d ", coprime[i]);
		if ((i+1) % 10 == 0)
		{
			printf("\n");
		}
	}
	
	printf("\n\nNumber of elements in coprime triplets: %d\n\n", ntrip);
	
	return 0;
}
