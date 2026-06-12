#include <stdio.h>
#include <stdint.h>

/* good enough for small numbers */
uint8_t prime(uint8_t n) {
    uint8_t f;
    if (n < 2) return 0;
    for (f = 2; f < n; f++) {
        if (n % f == 0) return 0;
    }
    return 1;
}

/* digit sum in given base */
uint8_t digit_sum(uint8_t n, uint8_t base) {
    uint8_t s = 0;
    do {s += n % base;} while (n /= base);
    return s;
}

int main() {
    uint8_t n, s = 0;
    for (n = 0; n < 200; n++) {
        if (prime(digit_sum(n,2)) && prime(digit_sum(n,3))) {
            printf("%4d",n);
            if (++s>=10) {
                printf("\n");
                s=0;
            }
        }
    }
    printf("\n");
    return 0;
}
