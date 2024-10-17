#include <stdio.h>
#include <stdlib.h>

/* return nth harmonic number */
double harmonic(int n) {
	double h, i;
	h = 0;
	for (i = 1; i <= (double) n; i += 1.0)
	  h += 1 / i;
	return h;
}

int main(void) {
	int i, n;
	printf("First 20 harmonic numbers:\n");
	for (i = 1; i <= 20; i++)
		printf("%2d  %8.6lf\n", i, harmonic(i));
	for (i = 1; i <= 5; i++) {
		int n = 2;
		while (harmonic(n) <= (double) i) n++;
		printf("First term > %d is at position %d\n", i, n);
	}
	return EXIT_SUCCESS;
}
