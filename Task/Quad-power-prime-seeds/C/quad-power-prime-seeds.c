#include <stdio.h>
#include <stdbool.h>
#include <locale.h>
#include <gmp.h>

mpz_t p, p2;

bool isQuadPowerPrimeSeed(unsigned int n) {
    int i;
    mpz_set_ui(p, n);
    unsigned int k = n + 1;
    mpz_add_ui(p2, p, k);
    if (!mpz_probab_prime_p(p2, 15)) return false;
    for (i = 0; i < 3; ++i) {
        mpz_mul_ui(p, p, n);
        mpz_set(p2, p);
        mpz_add_ui(p2, p2, k);
        if (!mpz_probab_prime_p(p2, 15)) return false;
    }
    return true;
}

const char *ord(int c) {
    int m = c % 100;
    if (m >= 4 && m <= 20) return "th";
    m %= 10;
    return (m == 1) ? "st" :
           (m == 2) ? "nd" :
           (m == 3) ? "rd" : "th";
}

int main() {
    unsigned int n;
    int c = 0, m = 1;
    mpz_init(p);
    mpz_init(p2);
    setlocale(LC_NUMERIC, "");
    printf("First fifty quad-power prime seeds:\n");
    for (n = 1; c < 50; ++n) {
        if (isQuadPowerPrimeSeed(n)) {
            printf("%'7u  ", n);
            if (!((++c) % 10)) printf("\n");
        }
    }

    printf("\nFirst quad-power prime seed greater than:\n");
    while (1) {
        if (isQuadPowerPrimeSeed(n)) {
            ++c;
            if (n > 1000000 * m) {
                printf(" %2d million is the %d%s: %'10u\n", m, c, ord(c), n);
                if (++m == 11) break;
            }
        }
        ++n;
    }
    return 0;
}
