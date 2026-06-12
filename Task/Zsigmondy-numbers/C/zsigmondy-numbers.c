#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

uint64_t ipow(uint64_t n, uint64_t p) {
    if (n == 1 || p == 0) return 1;
    uint64_t x = ipow(n, p>>1);
    return p&1 ? x*x*n : x*x;
}

uint64_t gcd(uint64_t a, uint64_t b) {
    return b ? gcd(b, a%b) : a;
}

bool all_coprime(uint64_t a, uint64_t b, uint64_t d, uint64_t n) {
    for (uint64_t m = 1; m < n; m++) {
        uint64_t dm = ipow(a,m)-ipow(b,m);
        if (gcd(dm, d) != 1) return false;
    }

    return true;
}

uint64_t zsigmondy(uint64_t n, uint64_t a, uint64_t b) {
    uint64_t dn = ipow(a,n) - ipow(b,n);

    uint64_t maxdiv = 0;
    for (uint64_t d = 1; d*d <= dn; d++) {
        if (dn % d != 0) continue;
        if (all_coprime(a, b, d, n))
            maxdiv = d > maxdiv ? d : maxdiv;

        uint64_t dnd = dn/d;
        if (all_coprime(a, b, dnd, n))
            maxdiv = dnd > maxdiv ? dnd : maxdiv;
    };

    return maxdiv;
}

void zsig_row(uint64_t a, uint64_t b) {
    printf("zsigmondy(n, %lu, %lu):\n", a, b);
    for (uint64_t n = 1; n <= 18; n++) {
        printf("%lu ", zsigmondy(n, a, b));
    }
    printf("\n");
}

int main(void) {
    uint64_t pairs[][2] = {
        {2, 1}, {3, 1}, {4, 1}, {5, 1}, {6, 1}, {7, 1},
        {3, 2}, {5, 3}, {7, 3}, {7, 5}
    };

    for (size_t pair=0; pair<sizeof(pairs)/sizeof(*pairs); pair++) {
        zsig_row(pairs[pair][0], pairs[pair][1]);
    }

    return 0;
}
