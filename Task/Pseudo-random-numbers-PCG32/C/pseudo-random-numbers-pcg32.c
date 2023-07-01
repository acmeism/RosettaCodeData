#include <math.h>
#include <stdint.h>
#include <stdio.h>

const uint64_t N = 6364136223846793005;

static uint64_t state = 0x853c49e6748fea9b;
static uint64_t inc = 0xda3e39cb94b95bdb;

uint32_t pcg32_int() {
    uint64_t old = state;
    state = old * N + inc;
    uint32_t shifted = (uint32_t)(((old >> 18) ^ old) >> 27);
    uint32_t rot = old >> 59;
    return (shifted >> rot) | (shifted << ((~rot + 1) & 31));
}

double pcg32_float() {
    return ((double)pcg32_int()) / (1LL << 32);
}

void pcg32_seed(uint64_t seed_state, uint64_t seed_sequence) {
    state = 0;
    inc = (seed_sequence << 1) | 1;
    pcg32_int();
    state = state + seed_state;
    pcg32_int();
}

int main() {
    int counts[5] = { 0, 0, 0, 0, 0 };
    int i;

    pcg32_seed(42, 54);
    printf("%u\n", pcg32_int());
    printf("%u\n", pcg32_int());
    printf("%u\n", pcg32_int());
    printf("%u\n", pcg32_int());
    printf("%u\n", pcg32_int());
    printf("\n");

    pcg32_seed(987654321, 1);
    for (i = 0; i < 100000; i++) {
        int j = (int)floor(pcg32_float() * 5.0);
        counts[j]++;
    }

    printf("The counts for 100,000 repetitions are:\n");
    for (i = 0; i < 5; i++) {
        printf("  %d : %d\n", i, counts[i]);
    }

    return 0;
}
