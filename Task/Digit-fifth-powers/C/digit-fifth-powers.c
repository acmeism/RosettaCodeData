#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int sum5( int n ) {
    if(n<10) return pow(n,5);
    return pow(n%10,5) + sum5(n/10);
}

int main(void) {
    int i, sum = 0;
    for(i=2;i<=999999;i++) {
        if(i==sum5(i)) {
            printf( "%d\n", i );
            sum+=i;
        }
    }
    printf( "Total is %d\n", sum );
    return 0;
}
