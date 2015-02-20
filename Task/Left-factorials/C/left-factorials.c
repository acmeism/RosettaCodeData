#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmp.h>

void mpz_left_fac_ui(mpz_t rop, unsigned long op)
{
    mpz_t t1;
    mpz_init_set_ui(t1, 1);
    mpz_set_ui(rop, 0);

    size_t i;
    for (i = 1; i <= op; ++i) {
        mpz_add(rop, rop, t1);
        mpz_mul_ui(t1, t1, i);
    }

    mpz_clear(t1);
}

size_t mpz_digitcount(mpz_t op)
{
    /* mpz_sizeinbase can not be trusted to give accurate base 10 length */
    char *t    = mpz_get_str(NULL, 10, op);
    size_t ret = strlen(t);
    free(t);
    return ret;
}

int main(void)
{
    mpz_t t;
    mpz_init(t);
    size_t i;

    for (i = 0; i <= 110; ++i) {
        if (i <= 10 || i % 10 == 0) {
            mpz_left_fac_ui(t, i);
            gmp_printf("!%u = %Zd\n", i, t);
        }
    }

    for (i = 1000; i <= 10000; i += 1000) {
        mpz_left_fac_ui(t, i);
        printf("!%u has %u digits\n", i, mpz_digitcount(t));
    }

    mpz_clear(t);
    return 0;
}
