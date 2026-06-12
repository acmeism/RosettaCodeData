#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <gmp.h>

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
    mpq_t q, r, s, u;
    mpz_t p, t;
    int count = 0, limit = 16;
    size_t len;
    bool isInteger;
    char *ps, a[44];
    mpq_inits(q, r, s, u, NULL);
    mpq_set_ui(u, 1, 1);
    mpz_inits(p, t, NULL);
    printf("First %d elements of the sequence:\n", limit);
    while (count < limit) {
        mpq_sub(q, u, s);
        mpq_inv(q, q);
        mpq_get_den(t, q);
        isInteger = !mpz_cmp_ui(t, 1);
        mpz_set_q(p, q);
        if (!isInteger) mpz_add_ui(p, p, 1);
        mpz_nextprime(p, p);
        ++count;
        ps = mpz_get_str(NULL, 10, p);
        len = strlen(ps);
        if (len <= 40) {
            printf("%2d: %s\n", count, ps);
        } else {
            abbreviate(a, ps);
            printf("%2d: %s (digits: %ld)\n", count, a, len);
        }
        mpq_set_z(r, p);
        mpq_inv(r, r);
        mpq_add(s, s, r);
    }
    mpq_clears(q, r, s, u, NULL);
    mpz_clears(p, t, NULL);
    return 0;
}
