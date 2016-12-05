/* 5432_pure.c */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

/* return = a * b.  Caller is responsible for freeing memory.
 * Handling of negatives, and zeros is not here, since not needed.
 */
unsigned char *str_mult(const unsigned char *A, const unsigned char *B)
{
	int ax = 0, bx = 0, rx = 0, al, bl;
	unsigned char *a, *b, *r; /* result */

	al = strlen(A); bl = strlen(B);
	r = calloc(al + bl + 1, 1);
	/* convert A and B from ASCII string numbers, into numeric */
	a = malloc(al+1); strcpy(a, A); for (ax = 0; ax < al; ++ax) a[ax] -= '0';
	b = malloc(bl+1); strcpy(b, B); for (bx = 0; bx < bl; ++bx) b[bx] -= '0';
	
	/* grade-school method of multiplication */
	for (ax = al - 1; ax >= 0; ax--) {
		int carry = 0;
		for (bx = bl - 1, rx = ax + bx + 1; bx >= 0; bx--, rx--) {
			int n = a[ax] * b[bx] + r[rx] + carry;
			r[rx] = (n % 10);
			carry = n / 10;
		}
		r[rx] += carry;
	}
	/* convert result from numeric into ASCII string numeric */
	for (rx = 0; rx < al + bl; ++rx)
		r[rx] += '0';
	while (r[0] == '0')
	    memmove(r, &r[1], al + bl);
	free(b); free(a);
	return r;
}

unsigned char *str_exp(int b, int n) {
  unsigned char *r, *tmp, *a;

  r = malloc(2); strcpy(r, "1");
  a = malloc(24); sprintf(a, "%d", b);

  while (n!=1) {
    if (n%2==1) {
	  tmp = str_mult(r, a);
	  free(r);
	  r = tmp;
    }
    n >>= 1;
	tmp = str_mult(a, a);
	free(a);
	a = tmp;
  }
  free(r);
  return a;
}

/* compute 5^4^3^2   which == 5^262144 */
int main() {
	unsigned char *r = str_exp(5,262144);
	printf ("Length of 5^4^3^2 is %d\n", strlen(r));
	printf ("First 20 digits:  %20.20s\n", r);
	printf ("Last 20 digits:   %s\n", &r[strlen(r)-20]);
	free(r);
	printf ("This took %.2f seconds\n", ((double)clock())/CLOCKS_PER_SEC);
}
