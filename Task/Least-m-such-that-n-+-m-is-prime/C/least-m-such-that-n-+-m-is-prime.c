#include <stdio.h>
#include <gmp.h>
#include <locale.h>

#define LIMIT 10000

int main() {
    mpz_t fact, p;
    mpz_init_set_ui(fact, 1);
    mpz_init(p);
    int i, diffs[50], t = 1000;
    unsigned long n, m;
    for (n = 0; ; ++n) {
        if (n > 0) mpz_mul_ui(fact, fact, n);
        mpz_nextprime(p, fact);
        mpz_sub(p, p, fact);
        m = mpz_get_ui(p);
        setlocale(LC_NUMERIC, "");
        if (n < 50) diffs[n] = m;
        if (n == 49) {
            printf("Least positive m such that n! + m is prime; first 50:\n");
            for (i = 0; i < 50; ++i) {
                printf("%3d  ", diffs[i]);
                if (!((i+1)%10)) printf("\n");
            }
            printf("\n");
        } else if (m > t) {
            do {
                printf("First m > %'6d is %'6ld at position %ld\n", t, m, n);
                t += 1000;
            } while (m > t);
            if (t > LIMIT) break;
        }
    }
    mpz_clear(fact);
    mpz_clear(p);
    return 0;
}
