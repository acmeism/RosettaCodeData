#include <stdbool.h>
#include <stdio.h>

bool prime(unsigned n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    for (unsigned d = 5; d*d <= n; d += 4) {
        if (n % d == 0) return false;
        d += 2;
        if (n % d == 0) return false;
    }
    return true;
}

bool sophie_germain(unsigned n) {
    return prime(n) && prime(2*n + 1);
}

int main(void) {
    unsigned n = 0;
    for (int amount = 50; amount > 0; amount--) {
        do { n++; } while (!sophie_germain(n));
        printf("%-6u", n);
        if (amount % 10 == 1) printf("\n");
    }
    return 0;
}
