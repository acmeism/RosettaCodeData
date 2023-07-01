#include <stdio.h>

unsigned int lpd(unsigned int n) {
    if (n<=1) return 1;
    int i;
    for (i=n-1; i>0; i--)
        if (n%i == 0) return i;
}

int main() {
    int i;
    for (i=1; i<=100; i++) {
        printf("%3d", lpd(i));
        if (i % 10 == 0) printf("\n");
    }
    return 0;
}
