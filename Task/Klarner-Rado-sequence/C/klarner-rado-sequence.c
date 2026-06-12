#include <stdio.h>

#define ELEMENTS 10000000U

void make_klarner_rado(unsigned int *dst, unsigned int n) {
    unsigned int i, i2 = 0, i3 = 0;
    unsigned int m, m2 = 1, m3 = 1;

    for (i = 0; i < n; ++i) {
        dst[i] = m = m2 < m3 ? m2 : m3;
        if (m2 == m) m2 = dst[i2++] << 1 | 1;
        if (m3 == m) m3 = dst[i3++] * 3 + 1;
    }
}

int main(void) {
    static unsigned int klarner_rado[ELEMENTS];
    unsigned int i;

    make_klarner_rado(klarner_rado, ELEMENTS);

    for (i = 0; i < 99; ++i)
        printf("%u ", klarner_rado[i]);
    for (i = 100; i <= ELEMENTS; i *= 10)
        printf("%u\n", klarner_rado[i - 1]);

    return 0;
}
