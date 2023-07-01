#include <locale.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

// Returns the sum of the digits of n given the
// sum of the digits of n - 1
uint64_t digit_sum(uint64_t n, uint64_t sum) {
    ++sum;
    while (n > 0 && n % 10 == 0) {
        sum -= 9;
        n /= 10;
    }
    return sum;
}

inline bool divisible(uint64_t n, uint64_t d) {
    if ((d & 1) == 0 && (n & 1) == 1)
        return false;
    return n % d == 0;
}

int main() {
    setlocale(LC_ALL, "");

    uint64_t previous = 1, gap = 0, sum = 0;
    int niven_index = 0, gap_index = 1;

    printf("Gap index  Gap    Niven index    Niven number\n");
    for (uint64_t niven = 1; gap_index <= 32; ++niven) {
        sum = digit_sum(niven, sum);
        if (divisible(niven, sum)) {
            if (niven > previous + gap) {
                gap = niven - previous;
                printf("%'9d %'4llu %'14d %'15llu\n", gap_index++,
                       gap, niven_index, previous);
            }
            previous = niven;
            ++niven_index;
        }
    }
    return 0;
}
