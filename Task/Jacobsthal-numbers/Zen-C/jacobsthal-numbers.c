//> link: -lgmp

import "gmp.h"

fn jacobsthal(r: mpz_t, n: c_ulong) {
    let s: mpz_t;
    mpz_init(s);
    mpz_set_ui(r, 1);
    mpz_mul_2exp(r, r, n);
    mpz_set_ui(s, 1);
    if n % 2 { mpz_neg(s, s); }
    mpz_sub(r, r, s);
    mpz_div_ui(r, r, 3);
    mpz_clear(s);
}

fn jacobsthal_lucas(r: mpz_t, n: c_ulong) {
    let a: mpz_t;
    mpz_init(a);
    mpz_set_ui(r, 1);
    mpz_mul_2exp(r, r, n);
    mpz_set_ui(a, 1);
    if n % 2 { mpz_neg(a, a); }
    mpz_add(r, r, a);
    mpz_clear(a);
}

fn main() {
    let jac: mpz_t[30];
    let j: mpz_t;
    println "First 30 Jacobsthal numbers:";
    for i in 0..30 {
        mpz_init(jac[i]);
        jacobsthal(jac[i], i);
        gmp_printf("%9Zd ", jac[i]);
        if !((i + 1) % 5) { println ""; }
    }

    println "\nFirst 30 Jacobsthal-Lucas numbers:";
    mpz_init(j);
    for i in 0..30 {
        jacobsthal_lucas(j, i);
        gmp_printf("%9Zd ", j);
        if !((i + 1) % 5) { println ""; }
    }

    println "\nFirst 20 Jacobsthal oblong numbers:";
    for i in 0..20 {
        mpz_mul(j, jac[i], jac[i + 1]);
        gmp_printf("%11Zd ", j);
        if !((i + 1) % 5) { println ""; }
    }

    println "\nFirst 20 Jacobsthal primes:";
    let count = 0;
    for let i = 0; count < 20; ++i {
        jacobsthal(j, i);
        if mpz_probab_prime_p(j, 15) > 0 {
            gmp_printf("%Zd\n", j);
            ++count;
        }
    }

    for i in 0..30 { mpz_clear(jac[i]); }
    mpz_clear(j);
}
