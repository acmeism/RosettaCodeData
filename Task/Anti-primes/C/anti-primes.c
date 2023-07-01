#include <stdio.h>

int countDivisors(int n) {
    int i, count;
    if (n < 2) return 1;
    count = 2; // 1 and n
    for (i = 2; i <= n/2; ++i) {
        if (n%i == 0) ++count;
    }
    return count;
}

int main() {
    int n, d, maxDiv = 0, count = 0;
    printf("The first 20 anti-primes are:\n");
    for (n = 1; count < 20; ++n) {
        d = countDivisors(n);
        if (d > maxDiv) {
            printf("%d ", n);
            maxDiv = d;
            count++;
        }
    }
    printf("\n");
    return 0;
}
