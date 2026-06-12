#include <stdio.h>
#include <string.h>
#include <gmp.h>

char *reverse(char *s) {
    int i, j, len = strlen(s);
    char t;
    for (i = 0, j = len - 1; i < j; ++i, --j) {
         t = s[i];
         s[i] = s[j];
         s[j] = t;
    }
    return s;
}

int main() {
    int count = 0;
    size_t len;
    char *s, a[44];
    mpz_t fib, p, prev, curr;
    mpz_init(fib);
    mpz_init(p);
    mpz_init_set_ui(prev, 0);
    mpz_init_set_ui(curr, 1);
    printf("First 30 Iccanobif primes:\n");
    while (count < 30) {
        mpz_add(fib, curr, prev);
        s = mpz_get_str(NULL, 10, fib);
        mpz_set_str(p, reverse(s), 10);
        if (mpz_probab_prime_p(p, 15) > 0) {
            ++count;
            s = mpz_get_str(NULL, 10, p);
            len = strlen(s);
            if (len > 40) {
                strncpy(a, s, 20);
                strcpy(a + 20, "...");
                strncpy(a + 23, s + len - 20, 21);
            }
            printf("%2d: %s (%ld digits)\n", count, len <= 40 ? s : a, len);
        }
        mpz_set(prev, curr);
        mpz_set(curr, fib);
    }
    mpz_clear(fib);
    mpz_clear(p);
    mpz_clear(prev);
    mpz_clear(curr);
    return 0;
}
