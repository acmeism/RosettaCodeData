#include <gmp.h>
#include <iostream>

using namespace std;

typedef unsigned long long int u64;

bool primality_pretest(u64 k) {     // for k > 23

    if (!(k %  3) || !(k %  5) || !(k %  7) || !(k % 11) ||
        !(k % 13) || !(k % 17) || !(k % 19) || !(k % 23)
    ) {
        return (k <= 23);
    }

    return true;
}

bool probprime(u64 k, mpz_t n) {
    mpz_set_ui(n, k);
    return mpz_probab_prime_p(n, 0);
}

bool is_chernick(int n, u64 m, mpz_t z) {

    if (!primality_pretest(6 * m + 1)) {
        return false;
    }

    if (!primality_pretest(12 * m + 1)) {
        return false;
    }

    u64 t = 9 * m;

    for (int i = 1; i <= n - 2; i++) {
        if (!primality_pretest((t << i) + 1)) {
            return false;
        }
    }

    if (!probprime(6 * m + 1, z)) {
        return false;
    }

    if (!probprime(12 * m + 1, z)) {
        return false;
    }

    for (int i = 1; i <= n - 2; i++) {
        if (!probprime((t << i) + 1, z)) {
            return false;
        }
    }

    return true;
}

int main() {

    mpz_t z;
    mpz_inits(z, NULL);

    for (int n = 3; n <= 10; n++) {

        // `m` is a multiple of 2^(n-4), for n > 4
        u64 multiplier = (n > 4) ? (1 << (n - 4)) : 1;

        // For n > 5, m is also a multiple of 5
        if (n > 5) {
            multiplier *= 5;
        }

        for (u64 k = 1; ; k++) {

            u64 m = k * multiplier;

            if (is_chernick(n, m, z)) {
                cout << "a(" << n << ") has m = " << m << endl;
                break;
            }
        }
    }

    return 0;
}
