#include <stdio.h>
#include <gmp.h>

void sum_multiples(mpz_t result, const mpz_t limit, const unsigned f)
{
    mpz_t m;
    mpz_init(m);
    mpz_sub_ui(m, limit, 1);
    mpz_fdiv_q_ui(m, m, f);

    mpz_init_set(result, m);
    mpz_add_ui(result, result, 1);
    mpz_mul(result, result, m);
    mpz_mul_ui(result, result, f);
    mpz_fdiv_q_2exp(result, result, 1);

    mpz_clear(m);
}

int main(int argc, char **argv)
{
    mpf_t temp;
    mpz_t limit;

    if (argc == 2)
    {
        mpf_init_set_str(temp, argv[1], 10);
        mpz_init(limit);
        mpz_set_f(limit, temp);
        mpf_clear(temp);
    }
    else
        mpz_init_set_str(limit, "1000000000000000000000", 10);

    mpz_t temp_sum;
    mpz_t sum35;

    mpz_init(temp_sum);
    sum_multiples(temp_sum, limit, 3);
    mpz_init_set(sum35, temp_sum);
    sum_multiples(temp_sum, limit, 5);
    mpz_add(sum35, sum35, temp_sum);
    sum_multiples(temp_sum, limit, 15);
    mpz_sub(sum35, sum35, temp_sum);

    mpz_out_str(stdout, 10, sum35);
    puts("");

    mpz_clear(temp_sum);
    mpz_clear(sum35);
    mpz_clear(limit);
    return 0;
}
