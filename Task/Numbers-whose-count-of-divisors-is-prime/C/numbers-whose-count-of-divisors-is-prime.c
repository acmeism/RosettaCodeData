#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <mem.h>

#define LIMIT 100000

bool isprime(int n) {
	if (n < 2) return false;
	if (n % 2 == 0) return (n == 2);
	for (int i = 3; i * i <= n; i += 2)
	    if (n % i == 0) return false;
	return true;
}

int main(void) {
	int i, j, sq, nfound, divcnt[LIMIT];
	printf("Numbers up to %d with a count of divisors that is prime\n", LIMIT);
	/* clear counts to zero */
	memset(divcnt, 0, sizeof(divcnt));
	/* create table of divisor counts */
	for (i = 1; i < LIMIT; i++)
	    for (j = i; j < LIMIT; j += i)
	        divcnt[j]++;
	/* only need to check numbers which are perfect squares */
	nfound = 0;
	for (i = 2; (sq = i * i) < LIMIT; i++) {
		if (isprime(divcnt[sq])) {
		    printf("%8d", sq);
		    nfound++;
		    if (nfound % 8 == 0) printf("\n");
		}
	}
	printf("\n%d were found\n", nfound);
	return EXIT_SUCCESS;
}
