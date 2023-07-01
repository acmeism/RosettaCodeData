#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmp.h>

int main() {
    for (unsigned int d = 2; d <= 9; ++d) {
        printf("First 10 super-%u numbers:\n", d);
        char digits[16] = { 0 };
        memset(digits, '0' + d, d);
        mpz_t bignum;
        mpz_init(bignum);
        for (unsigned int count = 0, n = 1; count < 10; ++n) {
            mpz_ui_pow_ui(bignum, n, d);
            mpz_mul_ui(bignum, bignum, d);
            char* str = mpz_get_str(NULL, 10, bignum);
            if (strstr(str, digits)) {
                printf("%u ", n);
                ++count;
            }
            free(str);
        }
        mpz_clear(bignum);
        printf("\n");
    }
    return 0;
}
