// contributed to rosettacode.org by Peter Helcmanovsky
// BCT = Binary-Coded Ternary: pairs of bits form one digit [0,1,2] (0b11 is invalid digit)

#include <cstdint>
#include <cstdlib>
#include <cstdio>

static constexpr int32_t bct_low_bits = 0x55555555;

static int32_t bct_decrement(int32_t v) {
    --v;            // either valid BCT (v-1), or block of bottom 0b00 digits becomes invalid 0b11
    return v ^ (v & (v>>1) & bct_low_bits);     // fix all 0b11 to 0b10 (digit "2")
}

int main (int argc, char *argv[])
{
    // parse N from first argument, if no argument, use 3 as default value
    const int32_t n = (1 < argc) ? std::atoi(argv[1]) : 3;
    // check for valid N (0..9) - 16 requires 33 bits for BCT form 1<<(n*2) => hard limit
    if (n < 0 || 9 < n) {                       // but N=9 already produces 370MB output
        std::printf("N out of range (use 0..9): %ld\n", long(n));
        return 1;
    }

    const int32_t size_bct = 1<<(n*2);          // 3**n in BCT form (initial value for loops)
    // draw the carpet, two nested loops counting down in BCT form of values
    int32_t y = size_bct;
    do {                                        // all lines loop
        y = bct_decrement(y);                   // --Y (in BCT)
        int32_t x = size_bct;
        do {                                    // line loop
            x = bct_decrement(x);               // --X (in BCT)
            // check if x has ternary digit "1" at same position(s) as y -> output space (hole)
            std::putchar((x & y & bct_low_bits) ? ' ' : '#');
        } while (0 < x);
        std::putchar('\n');
    } while (0 < y);

    return 0;
}
