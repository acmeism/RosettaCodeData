#include <stdio.h>

int* binomCoeff(int n) {
     int *b = calloc(n+1,sizeof(int));
     int j;
     b[0] = n%2 ? -1 : 1;
     for (j=1 ; j<=n; j++)
           b[j] = -b[j-1]*(n+1-j)/j;

     return(b);
};

main () {
    double array[] = { 90, 47, 58, 29, 22, 32, 55, 5, 55, 73 };
    size_t lenArray = sizeof(array)/sizeof(array[0]);	

    int p = 4;  // order
    int *b = binomCoeff(p);   // pre-compute binomial coefficients for order p

    int j, k;

    // compute p-th difference
    for (k=0 ; k < lenArray; k++)
        for (array[k] *= b[0], j=1 ; j<=p; j++)
            array[k] += b[j] * array[k+j];

    free(b);

    // resulting series is shorter by p elements
    lenArray -= p; 	
    for (k=0 ; k < lenArray; k++)  printf("%f ",array[k]);
    printf("\n");
}
