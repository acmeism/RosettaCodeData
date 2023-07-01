#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

typedef uint64_t integer;

integer reverse(integer n) {
    integer rev = 0;
    while (n > 0) {
        rev = rev * 10 + (n % 10);
        n /= 10;
    }
    return rev;
}

typedef struct palgen_tag {
    integer power;
    integer next;
    int digit;
    bool even;
} palgen_t;

void init_palgen(palgen_t* palgen, int digit) {
    palgen->power = 10;
    palgen->next = digit * palgen->power - 1;
    palgen->digit = digit;
    palgen->even = false;
}

integer next_palindrome(palgen_t* p) {
    ++p->next;
    if (p->next == p->power * (p->digit + 1)) {
        if (p->even)
            p->power *= 10;
        p->next = p->digit * p->power;
        p->even = !p->even;
    }
    return p->next * (p->even ? 10 * p->power : p->power)
        + reverse(p->even ? p->next : p->next/10);
}

bool gapful(integer n) {
    integer m = n;
    while (m >= 10)
        m /= 10;
    return n % (n % 10 + 10 * m) == 0;
}

void print(int len, integer array[][len]) {
    for (int digit = 1; digit < 10; ++digit) {
        printf("%d: ", digit);
        for (int i = 0; i < len; ++i)
            printf(" %llu", array[digit - 1][i]);
        printf("\n");
    }
}

int main() {
    const int n1 = 20, n2 = 15, n3 = 10;
    const int m1 = 100, m2 = 1000;

    integer pg1[9][n1];
    integer pg2[9][n2];
    integer pg3[9][n3];

    for (int digit = 1; digit < 10; ++digit) {
        palgen_t pgen;
        init_palgen(&pgen, digit);
        for (int i = 0; i < m2; ) {
            integer n = next_palindrome(&pgen);
            if (!gapful(n))
                continue;
            if (i < n1)
                pg1[digit - 1][i] = n;
            else if (i < m1 && i >= m1 - n2)
                pg2[digit - 1][i - (m1 - n2)] = n;
            else if (i >= m2 - n3)
                pg3[digit - 1][i - (m2 - n3)] = n;
            ++i;
        }
    }

    printf("First %d palindromic gapful numbers ending in:\n", n1);
    print(n1, pg1);

    printf("\nLast %d of first %d palindromic gapful numbers ending in:\n", n2, m1);
    print(n2, pg2);

    printf("\nLast %d of first %d palindromic gapful numbers ending in:\n", n3, m2);
    print(n3, pg3);

    return 0;
}
