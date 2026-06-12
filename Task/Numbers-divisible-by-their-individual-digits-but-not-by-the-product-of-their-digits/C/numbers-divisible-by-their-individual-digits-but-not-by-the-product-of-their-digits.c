#include <stdio.h>

int divisible(int n) {
    int p = 1;
    int c, d;

    for (c=n; c; c /= 10) {
        d = c % 10;
        if (!d || n % d) return 0;
        p *= d;
    }

    return n % p;
}

int main() {
    int n, c=0;

    for (n=1; n<1000; n++) {
        if (divisible(n)) {
            printf("%5d", n);
            if (!(++c % 10)) printf("\n");
        }
    }
    printf("\n");

    return 0;
}
