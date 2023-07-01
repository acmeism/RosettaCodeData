#include <algorithm>
#include <bitset>
#include <iostream>
#include <vector>

typedef unsigned long ulong;
std::vector<ulong> primes;

typedef struct {
    ulong p, e;
} prime_factor; /* prime, exponent */

void sieve() {
    /* 65536 = 2^16, so we can factor all 32 bit ints */
    constexpr int SIZE = 1 << 16;

    std::bitset<SIZE> bits;
    bits.flip(); // set all bits
    bits.reset(0);
    bits.reset(1);
    for (int i = 0; i < 256; i++) {
        if (bits.test(i)) {
            for (int j = i * i; j < SIZE; j += i) {
                bits.reset(j);
            }
        }
    }

    /* collect primes into a list. slightly faster this way if dealing with large numbers */
    for (int i = 0; i < SIZE; i++) {
        if (bits.test(i)) {
            primes.push_back(i);
        }
    }
}

auto get_prime_factors(ulong n) {
    std::vector<prime_factor> lst;
    ulong e, p;

    for (ulong i = 0; i < primes.size(); i++) {
        p = primes[i];
        if (p * p > n) break;
        for (e = 0; !(n % p); n /= p, e++);
        if (e) {
            lst.push_back({ p, e });
        }
    }

    if (n != 1) {
        lst.push_back({ n, 1 });
    }
    return lst;
}

auto get_factors(ulong n) {
    auto f = get_prime_factors(n);
    std::vector<ulong> lst{ 1 };

    size_t len2 = 1;
    /* L = (1); L = (L, L * p**(1 .. e)) forall((p, e)) */
    for (size_t i = 0; i < f.size(); i++, len2 = lst.size()) {
        for (ulong j = 0, p = f[i].p; j < f[i].e; j++, p *= f[i].p) {
            for (size_t k = 0; k < len2; k++) {
                lst.push_back(lst[k] * p);
            }
        }
    }

    std::sort(lst.begin(), lst.end());
    return lst;
}

ulong mpow(ulong a, ulong p, ulong m) {
    ulong r = 1;
    while (p) {
        if (p & 1) {
            r = r * a % m;
        }
        a = a * a % m;
        p >>= 1;
    }
    return r;
}

ulong ipow(ulong a, ulong p) {
    ulong r = 1;
    while (p) {
        if (p & 1) r *= a;
        a *= a;
        p >>= 1;
    }
    return r;
}

ulong gcd(ulong m, ulong n) {
    ulong t;
    while (m) {
        t = m;
        m = n % m;
        n = t;
    }
    return n;
}

ulong lcm(ulong m, ulong n) {
    ulong g = gcd(m, n);
    return m / g * n;
}

ulong multi_order_p(ulong a, ulong p, ulong e) {
    ulong m = ipow(p, e);
    ulong t = m / p * (p - 1);
    auto fac = get_factors(t);
    for (size_t i = 0; i < fac.size(); i++) {
        if (mpow(a, fac[i], m) == 1) {
            return fac[i];
        }
    }
    return 0;
}

ulong multi_order(ulong a, ulong m) {
    auto pf = get_prime_factors(m);
    ulong res = 1;
    for (size_t i = 0; i < pf.size(); i++) {
        res = lcm(res, multi_order_p(a, pf[i].p, pf[i].e));
    }
    return res;
}

int main() {
    sieve();

    printf("%lu\n", multi_order(37, 1000));   // expect 100
    printf("%lu\n", multi_order(54, 100001)); // expect 9090

    return 0;
}
