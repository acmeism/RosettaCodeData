#include <stdio.h>
#include <stdbool.h>

bool isPrime(int n) {
    if (n < 2) return false;
    if (n%2 == 0) return n == 2;
    if (n%3 == 0) return n == 3;
    int d = 5;
    while (d*d <= n) {
        if (n%d == 0) return false;
        d += 2;
        if (n%d == 0) return false;
        d += 4;
    }
    return true;
}

int main() {
    printf("Double twin primes under 1,000:\n");
    for (int i = 3; i < 992; i+=2) {
        if (isPrime(i) && isPrime(i+2) && isPrime(i+6) && isPrime(i+8)) {
            printf("%4d %4d %4d %4d\n", i, i+2, i+6, i+8);
        }
    }
    return 0;
}
