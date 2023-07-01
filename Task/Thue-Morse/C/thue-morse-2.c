#include <stdio.h>

/**
 * description : Counts the number of bits set to 1
 *        input: the number to have its bit counted
 *       output: the number of bits set to 1
 */
unsigned count_bits(unsigned v) {
    unsigned c = 0;
    while (v) {
        c += v & 1;
        v >>= 1;
    }

    return c;
}

int main(void) {
    for (unsigned i = 0; i < 256; ++i) {
        putchar('0' + count_bits(i) % 2);
    }
    putchar('\n');

    return 0;
}
