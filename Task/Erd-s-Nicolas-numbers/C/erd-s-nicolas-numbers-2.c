#include <stdio.h>
#include <stdlib.h>

void get_div_cnt(int n){
	int lmt,f,divcnt,divsum;
	divsum = 1;
	divcnt = 1;
	lmt = n/2;
    f = 2;
	for (;;) {
	  if (f > lmt ) break;
	  if (!(n % f)){
		  divsum +=f;
		  divcnt++;
	  }
	  if (divsum == n) break;
      f++;
	}
    printf("%8d equals the sum of its first %d divisors\n", n, divcnt);	
}

int main() {
    const int maxNumber = 100*1000*1000;
    int *dsum = (int *)malloc((maxNumber + 1) * sizeof(int));
    int i, j;
    for (i = 0; i <= maxNumber; ++i) {
        dsum[i] = 1;
    }
    for (i = 2; i <= maxNumber; ++i) {
        for (j = i + i; j <= maxNumber; j += i) {
        if (dsum[j] == j) get_div_cnt(j);
        dsum[j] += i;
        }
    }
    free(dsum);
    return 0;
}
