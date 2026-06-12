#include <stdio.h>
#include <stdbool.h>

bool isPrime(int n) {
    int d;
    if (n < 2)  return false;
    if (!(n%2)) return n == 2;
    if (!(n%3)) return n == 3;
    d = 5;
    while (d*d <= n) {
        if (!(n%d)) return false;
        d += 2;
        if (!(n%d)) return false;
        d += 4;
    }
    return true;
}

int main() {
    int i, lastSpecial = 3, lastGap = 1;
    printf("Special primes under 1,050:\n");
    printf("Prime1 Prime2 Gap\n");
    printf("%6d %6d %3d\n", 2, 3, lastGap);
    for (i = 5; i < 1050; i += 2) {
        if (isPrime(i) && (i-lastSpecial) > lastGap) {
            lastGap = i - lastSpecial;
            printf("%6d %6d %3d\n", lastSpecial, i, lastGap);
            lastSpecial = i;
        }
    }
}
