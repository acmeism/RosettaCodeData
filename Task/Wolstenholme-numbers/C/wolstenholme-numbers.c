#include <stdio.h>
#include <string.h>
#include <gmp.h>
#include <locale.h>

const char *ord(unsigned long c) {
    int m = c % 100;
    if (m >= 4 && m <= 20) return "th";
    m %= 10;
    return (m == 1) ? "st" :
           (m == 2) ? "nd" :
           (m == 3) ? "rd" : "th";
}

void abbreviate(char a[], const char *s) {
    size_t len = strlen(s);
    if (len < 40) {
        strcpy(a, s);
        return;
    }
    strncpy(a, s, 20);
    strcpy(a + 20, "...");
    strncpy(a + 23, s + len - 20, 21);
}

int main() {
    int i, pc = 0, si = 0;
    unsigned long k, l[5] = {500, 1000, 2500, 5000, 10000};
    char *s, a[44];
    mpq_t w, h;
    mpz_t n, primes[15];
    mpq_init(w);
    mpq_init(h);
    mpz_init(n);
    for (i = 0; i < 15; ++i) mpz_init(primes[i]);
    printf("Wolstenholme numbers:\n");
    setlocale(LC_NUMERIC, "");
    for (k = 1; k <= 10000; ++k) {
        mpq_set_ui(h, 1, k * k);
        mpq_add(w, w, h);
        mpq_get_num(n, w);
        if (pc < 15 && mpz_probab_prime_p(n, 15) > 0) mpz_set(primes[pc++], n);
        if (k <= 20) {
            s = mpz_get_str(NULL, 10, n);
            printf("%6ld%s: %s\n", k, ord(k), s);
        } else if (k == l[si]) {
            s = mpz_get_str(NULL, 10, n);
            abbreviate(a, s);
            printf("%'6ld%s: %s (digits: %ld)\n", k, ord(k), a, strlen(s));
            ++si;
        }
    }
    printf("\nPrime Wolstenholme numbers:\n");
    for (i = 0; i < 15; ++i) {
        s = mpz_get_str(NULL, 10, primes[i]);
        if (i < 4) {
            printf("%6d%s: %s\n", i+1, ord(i+1), s);
        } else {
            abbreviate(a, s);
            printf("%'6d%s: %s (digits: %ld)\n", i+1, ord(i+1), a, strlen(s));
        }
    }
    mpq_clear(w);
    mpq_clear(h);
    mpz_clear(n);
    for (i = 0; i < 15; ++i) mpz_clear(primes[i]);
    return 0;
}
