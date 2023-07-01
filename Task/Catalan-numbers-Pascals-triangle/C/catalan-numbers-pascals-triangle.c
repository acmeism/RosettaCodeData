//This code implements the print of 15 first Catalan's Numbers
//Formula used:
//  __n__
//   | |  (n + k) / k  n>0
//   k=2

#include <stdio.h>
#include <stdlib.h>

//the number of Catalan's Numbers to be printed
const int N = 15;

int main()
{
    //loop variables (in registers)
    register int k, n;

    //necessarily ull for reach big values
    unsigned long long int num, den;

    //the nmmber
    int catalan;

    //the first is not calculated for the formula
    printf("1 ");

    //iterating from 2 to 15
    for (n=2; n<=N; ++n) {
        //initializaing for products
        num = den = 1;
        //applying the formula
        for (k=2; k<=n; ++k) {
            num *= (n+k);
            den *= k;
            catalan = num /den;
        }

        //output
        printf("%d ", catalan);
    }

    //the end
    printf("\n");
    return 0;
}
