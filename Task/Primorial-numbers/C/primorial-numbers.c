#include <inttypes.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <gmp.h>

/* Eratosthenes bit-sieve */
int es_check(uint32_t *sieve, uint64_t n)
{
    if ((n != 2 && !(n & 1)) || (n < 2))
        return 0;
    else
        return !(sieve[n >> 6] & (1 << (n >> 1 & 31)));
}

uint32_t *es_sieve(const uint64_t nth, uint64_t *es_size)
{
    *es_size = nth * log(nth) + nth * (log(log(nth)) - 0.9385f) + 1;
    uint32_t *sieve = calloc((*es_size >> 6) + 1, sizeof(uint32_t));

    for (uint64_t i = 3; i < sqrt(*es_size) + 1; i += 2)
        if (!(sieve[i >> 6] & (1 << (i >> 1 & 31))))
            for (uint64_t j = i * i; j < *es_size; j += (i << 1))
                sieve[j >> 6] |= (1 << (j >> 1 & 31));

    return sieve;
}

size_t mpz_number_of_digits(const mpz_t op)
{
    char *opstr = mpz_get_str(NULL, 10, op);
    const size_t oplen = strlen(opstr);
    free(opstr);
    return oplen;
}

#define PRIMORIAL_LIMIT 1000000

int main(void)
{
    /* Construct a sieve of the first 1,000,000 primes */
    uint64_t sieve_size;
    uint32_t *sieve = es_sieve(PRIMORIAL_LIMIT, &sieve_size);

    mpz_t primorial;
    mpz_init_set_ui(primorial, 1);

    uint64_t prime_count = 0;
    int print = 1;
    double unused;

    for (uint64_t i = 2; i < sieve_size && prime_count <= PRIMORIAL_LIMIT; ++i) {
        if (print) {
            if (prime_count < 10)
                gmp_printf("Primorial(%" PRIu64 ") = %Zd\n", prime_count, primorial);
            /* Is the current number a power of 10? */
            else if (!modf(log10(prime_count), &unused))
                printf("Primorial(%" PRIu64 ") has %zu digits\n", prime_count, mpz_number_of_digits(primorial));
            print = 0;
        }

        if (es_check(sieve, i)) {
            mpz_mul_ui(primorial, primorial, i);
            prime_count++;
            print = 1;
        }

    }

    free(sieve);
    mpz_clear(primorial);
    return 0;
}
