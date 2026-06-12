#include <stdio.h>
#include <stdint.h>

uint8_t bit_length(uint32_t n) {
    uint8_t r;
    for (r=0; n; r++) n >>= 1;
    return r;
}

uint32_t concat_bits(uint32_t n) {
    return (n << bit_length(n)) | n;
}

char *bits(uint32_t n) {
    static char buf[33];
    char *ptr = &buf[33];
    *--ptr = 0;
    do {
        *--ptr = '0' + (n & 1);
    } while (n >>= 1);
    return ptr;
}

int main() {
    uint32_t n, r;
    for (n=1; (r = concat_bits(n)) < 1000; n++) {
        printf("%d: %s\n", r, bits(r));
    }
    return 0;
}
