#include <stdint.h>
#include <stdio.h>

uint64_t factorial(uint64_t n) {
    uint64_t res = 1;
    if (n == 0) return res;
    while (n > 0) res *= n--;
    return res;
}

uint64_t lah(uint64_t n, uint64_t k) {
    if (k == 1) return factorial(n);
    if (k == n) return 1;
    if (k > n) return 0;
    if (k < 1 || n < 1) return 0;
    return (factorial(n) * factorial(n - 1)) / (factorial(k) * factorial(k - 1)) / factorial(n - k);
}

int main() {
    int row, i;

    printf("Unsigned Lah numbers: L(n, k):\n");
    printf("n/k ");
    for (i = 0; i < 13; i++) {
        printf("%10d ", i);
    }
    printf("\n");
    for (row = 0; row < 13; row++) {
        printf("%-3d", row);
        for (i = 0; i < row + 1; i++) {
            uint64_t l = lah(row, i);
            printf("%11lld", l);
        }
        printf("\n");
    }

    return 0;
}
