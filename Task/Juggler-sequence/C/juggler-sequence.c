#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

// for a starting value of n, return the length of the sequence,
// the highest value in the sequence, and the index of that value
void juggler(uint64_t n, uint64_t *slen, uint64_t *h, uint64_t *i) {
	uint64_t k;
	*slen = 1;
	*h = n;
	*i = 0;
	k = 0;
	while (n != 1) {
		if (n % 2 == 0)
		    n = (uint64_t) pow((double) n, 0.5);
		else
		    n = (uint64_t) pow((double) n, 1.5);
		k++;
		if (n > *h) {
			*h = n;
			*i = k;
		}
	}
	*slen = k;
}

int main(void) {
	uint64_t k, len, highval, highpos;
	printf("n     l(n)             h(n)    i(n)  \n");
	printf("-------------------------------------\n");
	for (k = 20; k <= 39; k++) {
		juggler(k, &len, &highval, &highpos);
		printf("%llu    %3llu    %14llu    %3llu\n", k, len, highval, highpos);
	}
	return EXIT_SUCCESS;
}
