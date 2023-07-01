#include <stdio.h>

void divisor_count_and_sum(unsigned int n, unsigned int* pcount,
                           unsigned int* psum) {
    unsigned int divisor_count = 1;
    unsigned int divisor_sum = 1;
    unsigned int power = 2;
    for (; (n & 1) == 0; power <<= 1, n >>= 1) {
        ++divisor_count;
        divisor_sum += power;
    }
    for (unsigned int p = 3; p * p <= n; p += 2) {
        unsigned int count = 1, sum = 1;
        for (power = p; n % p == 0; power *= p, n /= p) {
            ++count;
            sum += power;
        }
        divisor_count *= count;
        divisor_sum *= sum;
    }
    if (n > 1) {
        divisor_count *= 2;
        divisor_sum *= n + 1;
    }
    *pcount = divisor_count;
    *psum = divisor_sum;
}

int main() {
    unsigned int arithmetic_count = 0;
    unsigned int composite_count = 0;

    for (unsigned int n = 1; arithmetic_count <= 1000000; ++n) {
        unsigned int divisor_count;
        unsigned int divisor_sum;
        divisor_count_and_sum(n, &divisor_count, &divisor_sum);
        if (divisor_sum % divisor_count != 0)
            continue;
        ++arithmetic_count;
        if (divisor_count > 2)
            ++composite_count;
        if (arithmetic_count <= 100) {
            printf("%3u ", n);
            if (arithmetic_count % 10 == 0)
                printf("\n");
        }
        if (arithmetic_count == 1000 || arithmetic_count == 10000 ||
            arithmetic_count == 100000 || arithmetic_count == 1000000) {
            printf("\n%uth arithmetic number is %u\n", arithmetic_count, n);
            printf("Number of composite arithmetic numbers <= %u: %u\n", n,
                   composite_count);
        }
    }
    return 0;
}
