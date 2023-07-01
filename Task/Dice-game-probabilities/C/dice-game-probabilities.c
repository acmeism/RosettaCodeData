#include <stdio.h>
#include <stdint.h>

typedef uint32_t uint;
typedef uint64_t ulong;

ulong ipow(const uint x, const uint y) {
    ulong result = 1;
    for (uint i = 1; i <= y; i++)
        result *= x;
    return result;
}

uint min(const uint x, const uint y) {
    return (x < y) ? x : y;
}

void throw_die(const uint n_sides, const uint n_dice, const uint s, uint counts[]) {
    if (n_dice == 0) {
        counts[s]++;
        return;
    }

    for (uint i = 1; i < n_sides + 1; i++)
        throw_die(n_sides, n_dice - 1, s + i, counts);
}

double beating_probability(const uint n_sides1, const uint n_dice1,
                           const uint n_sides2, const uint n_dice2) {
    const uint len1 = (n_sides1 + 1) * n_dice1;
    uint C1[len1];
    for (uint i = 0; i < len1; i++)
        C1[i] = 0;
    throw_die(n_sides1, n_dice1, 0, C1);

    const uint len2 = (n_sides2 + 1) * n_dice2;
    uint C2[len2];
    for (uint j = 0; j < len2; j++)
        C2[j] = 0;
    throw_die(n_sides2, n_dice2, 0, C2);

    const double p12 = (double)(ipow(n_sides1, n_dice1) * ipow(n_sides2, n_dice2));

    double tot = 0;
    for (uint i = 0; i < len1; i++)
        for (uint j = 0; j < min(i, len2); j++)
            tot += (double)C1[i] * C2[j] / p12;
    return tot;
}

int main() {
    printf("%1.16f\n", beating_probability(4, 9, 6, 6));
    printf("%1.16f\n", beating_probability(10, 5, 7, 6));
    return 0;
}
