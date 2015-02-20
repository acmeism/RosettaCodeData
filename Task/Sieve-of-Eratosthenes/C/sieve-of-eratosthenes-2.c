#include <stdio.h>
#include <malloc.h>
void sieve(int *, int);

int main(int argc, char *argv)
{
    int *array, n=10;
    array =(int *)malloc(sizeof(int));
    sieve(array,n);
    return 0;
}

void sieve(int *a, int n)
{
    int i=0, j=0;

    for(i=2; i<=n; i++) {
        a[i] = 1;
    }

    for(i=2; i<=n; i++) {
        printf("\ni:%d", i);
        if(a[i] == 1) {
            for(j=i; (i*j)<=n; j++) {
                printf ("\nj:%d", j);
                printf("\nBefore a[%d*%d]: %d", i, j, a[i*j]);
                a[(i*j)] = 0;
                printf("\nAfter a[%d*%d]: %d", i, j, a[i*j]);
            }
        }
    }

    printf("\nPrimes numbers from 1 to %d are : ", n);
    for(i=2; i<=n; i++) {
        if(a[i] == 1)
            printf("%d, ", i);
    }
    printf("\n\n");
}
