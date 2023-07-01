#include <iostream>
#include <cstdint>

typedef uint64_t integer;

integer bit_count(integer n) {
    integer count = 0;
    for (; n > 0; count++)
        n >>= 1;
    return count;
}

integer mod_pow(integer p, integer n) {
    integer square = 1;
    for (integer bits = bit_count(p); bits > 0; square %= n) {
        square *= square;
        if (p & (1 << --bits))
            square <<= 1;
    }
    return square;
}

bool is_prime(integer n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    for (integer p = 3; p * p <= n; p += 2)
        if (n % p == 0)
            return false;
    return true;
}

integer find_mersenne_factor(integer p) {
    for (integer k = 0, q = 1;;) {
        q = 2 * ++k * p + 1;
        if ((q % 8 == 1 || q % 8 == 7) && mod_pow(p, q) == 1 && is_prime(q))
            return q;
    }
    return 0;
}

int main() {
    std::cout << find_mersenne_factor(929) << std::endl;
    return 0;
}
