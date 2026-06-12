#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct fp2 {
    int64_t x, y;
};

uint64_t randULong(uint64_t min, uint64_t max) {
    uint64_t t = (uint64_t)rand();
    return min + t % (max - min);
}

// returns a * b mod modulus
uint64_t mul_mod(uint64_t a, uint64_t b, uint64_t modulus) {
    uint64_t x = 0, y = a % modulus;

    while (b > 0) {
        if ((b & 1) == 1) {
            x = (x + y) % modulus;
        }
        y = (y << 1) % modulus;
        b = b >> 1;
    }

    return x;
}

//returns b ^^ power mod modulus
uint64_t pow_mod(uint64_t b, uint64_t power, uint64_t modulus) {
    uint64_t x = 1;

    while (power > 0) {
        if ((power & 1) == 1) {
            x = mul_mod(x, b, modulus);
        }
        b = mul_mod(b, b, modulus);
        power = power >> 1;
    }

    return x;
}

// miller-rabin prime test
bool isPrime(uint64_t n, int64_t k) {
    uint64_t a, x, n_one = n - 1, d = n_one;
    uint32_t s = 0;
    uint32_t r;

    if (n < 2) {
        return false;
    }

    // limit 2^63, pow_mod/mul_mod can't handle bigger numbers
    if (n > 9223372036854775808ull) {
        printf("The number is too big, program will end.\n");
        exit(1);
    }

    if ((n % 2) == 0) {
        return n == 2;
    }

    while ((d & 1) == 0) {
        d = d >> 1;
        s = s + 1;
    }

    while (k > 0) {
        k = k - 1;
        a = randULong(2, n);
        x = pow_mod(a, d, n);
        if (x == 1 || x == n_one) {
            continue;
        }
        for (r = 1; r < s; r++) {
            x = pow_mod(x, 2, n);
            if (x == 1) return false;
            if (x == n_one) goto continue_while;
        }
        if (x != n_one) {
            return false;
        }

    continue_while: {}
    }

    return true;
}

int64_t legendre_symbol(int64_t a, int64_t p) {
    int64_t x = pow_mod(a, (p - 1) / 2, p);
    if ((p - 1) == x) {
        return x - p;
    } else {
        return x;
    }
}

struct fp2 fp2mul(struct fp2 a, struct fp2 b, int64_t p, int64_t w2) {
    struct fp2 answer;
    uint64_t tmp1, tmp2;

    tmp1 = mul_mod(a.x, b.x, p);
    tmp2 = mul_mod(a.y, b.y, p);
    tmp2 = mul_mod(tmp2, w2, p);
    answer.x = (tmp1 + tmp2) % p;
    tmp1 = mul_mod(a.x, b.y, p);
    tmp2 = mul_mod(a.y, b.x, p);
    answer.y = (tmp1 + tmp2) % p;

    return answer;
}

struct fp2 fp2square(struct fp2 a, int64_t p, int64_t w2) {
    return fp2mul(a, a, p, w2);
}

struct fp2 fp2pow(struct fp2 a, int64_t n, int64_t p, int64_t w2) {
    struct fp2 ret;

    if (n == 0) {
        ret.x = 1;
        ret.y = 0;
        return ret;
    }
    if (n == 1) {
        return a;
    }
    if ((n & 1) == 0) {
        return fp2square(fp2pow(a, n / 2, p, w2), p, w2);
    } else {
        return fp2mul(a, fp2pow(a, n - 1, p, w2), p, w2);
    }
}

void test(int64_t n, int64_t p) {
    int64_t a, w2;
    int64_t x1, x2;
    struct fp2 answer;

    printf("Find solution for n = %lld and p = %lld\n", n, p);
    if (p == 2 || !isPrime(p, 15)) {
        printf("No solution, p is not an odd prime.\n\n");
        return;
    }

    //p is checked and is a odd prime
    if (legendre_symbol(n, p) != 1) {
        printf(" %lld is not a square in F%lld\n\n", n, p);
        return;
    }

    while (true) {
        do {
            a = randULong(2, p);
            w2 = a * a - n;
        } while (legendre_symbol(w2, p) != -1);

        answer.x = a;
        answer.y = 1;
        answer = fp2pow(answer, (p + 1) / 2, p, w2);
        if (answer.y != 0) {
            continue;
        }

        x1 = answer.x;
        x2 = p - x1;
        if (mul_mod(x1, x1, p) == n && mul_mod(x2, x2, p) == n) {
            printf("Solution found: x1 = %lld, x2 = %lld\n\n", x1, x2);
            return;
        }
    }
}

int main() {
    srand((size_t)time(0));

    test(10, 13);
    test(56, 101);
    test(8218, 10007);
    test(8219, 10007);
    test(331575, 1000003);
    test(665165880, 1000000007);
    //test(881398088036, 1000000000039);

    return 0;
}
