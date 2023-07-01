#include <stdlib.h>
#include <gmp.h>

#define mpq_for(buf, op, n)\
    do {\
        size_t i;\
        for (i = 0; i < (n); ++i)\
            mpq_##op(buf[i]);\
    } while (0)

void bernoulli(mpq_t rop, unsigned int n)
{
    unsigned int m, j;
    mpq_t *a = malloc(sizeof(mpq_t) * (n + 1));
    mpq_for(a, init, n + 1);

    for (m = 0; m <= n; ++m) {
        mpq_set_ui(a[m], 1, m + 1);
        for (j = m; j > 0; --j) {
            mpq_sub(a[j-1], a[j], a[j-1]);
            mpq_set_ui(rop, j, 1);
            mpq_mul(a[j-1], a[j-1], rop);
        }
    }

    mpq_set(rop, a[0]);
    mpq_for(a, clear, n + 1);
    free(a);
}

int main(void)
{
    mpq_t rop;
    mpz_t n, d;
    mpq_init(rop);
    mpz_inits(n, d, NULL);

    unsigned int i;
    for (i = 0; i <= 60; ++i) {
        bernoulli(rop, i);
        if (mpq_cmp_ui(rop, 0, 1)) {
            mpq_get_num(n, rop);
            mpq_get_den(d, rop);
            gmp_printf("B(%-2u) = %44Zd / %Zd\n", i, n, d);
        }
    }

    mpz_clears(n, d, NULL);
    mpq_clear(rop);
    return 0;
}
