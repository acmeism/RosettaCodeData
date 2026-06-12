#include<stdio.h>
#include<stdlib.h>

int f(int n) {
    int i, i1;
    for(i=1;i*i-i1*i1<n;i1=i, i++);
    return i;
}

int main(void) {
    printf( "%d\n", f(1000) );
    return 0;
}
