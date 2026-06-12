#include <stdio.h>
#include <stdint.h>

uint64_t ones_plus_three(uint64_t ones) {
    uint64_t r = 0;
    while (ones--) r = r*10 + 1;
    return r*10 + 3;
}

int main() {
    uint64_t n;
    for (n=0; n<8; n++) {
        uint64_t x = ones_plus_three(n);
        printf("%8lu^2 = %15lu\n", x, x*x);
    }
    return 0;
}
