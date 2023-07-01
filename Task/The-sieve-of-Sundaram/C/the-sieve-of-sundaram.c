#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main(void) {
    int nprimes =  1000000;
    int nmax =    ceil(nprimes*(log(nprimes)+log(log(nprimes))-0.9385));
      // should be larger than the last prime wanted; See
      // https://www.maa.org/sites/default/files/jaroma03200545640.pdf
    int i, j, m, k; int *a;
    k = (nmax-2)/2;
    a = (int *)calloc(k + 1, sizeof(int));
    for(i = 0; i <= k; i++)a[i] = 2*i+1;
    for (i = 1; (i+1)*i*2 <= k; i++)
        for (j = i; j <= (k-i)/(2*i+1); j++) {
            m = i + j + 2*i*j;
            if(a[m]) a[m] = 0;
            }

    for (i = 1, j = 0; i <= k; i++)
       if (a[i]) {
           if(j%10 == 0 && j <= 100)printf("\n");
           j++;
           if(j <= 100)printf("%3d ", a[i]);
           else if(j == nprimes){
               printf("\n%d th prime is %d\n",j,a[i]);
               break;
               }
           }
}
