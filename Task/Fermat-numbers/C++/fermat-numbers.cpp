#include <iostream>
#include <vector>
#include <boost/integer/common_factor.hpp>
#include <boost/multiprecision/cpp_int.hpp>
#include <boost/multiprecision/miller_rabin.hpp>

typedef boost::multiprecision::cpp_int integer;

integer fermat(unsigned int n) {
    unsigned int p = 1;
    for (unsigned int i = 0; i < n; ++i)
        p *= 2;
    return 1 + pow(integer(2), p);
}

inline void g(integer& x, const integer& n) {
    x *= x;
    x += 1;
    x %= n;
}

integer pollard_rho(const integer& n) {
    integer x = 2, y = 2, d = 1, z = 1;
    int count = 0;
    for (;;) {
        g(x, n);
        g(y, n);
        g(y, n);
        d = abs(x - y);
        z = (z * d) % n;
        ++count;
        if (count == 100) {
            d = gcd(z, n);
            if (d != 1)
                break;
            z = 1;
            count = 0;
        }
    }
    if (d == n)
        return 0;
    return d;
}

std::vector<integer> get_prime_factors(integer n) {
    std::vector<integer> factors;
    for (;;) {
        if (miller_rabin_test(n, 25)) {
            factors.push_back(n);
            break;
        }
        integer f = pollard_rho(n);
        if (f == 0) {
            factors.push_back(n);
            break;
        }
        factors.push_back(f);
        n /= f;
    }
    return factors;
}

void print_vector(const std::vector<integer>& factors) {
    if (factors.empty())
        return;
    auto i = factors.begin();
    std::cout << *i++;
    for (; i != factors.end(); ++i)
        std::cout << ", " << *i;
    std::cout << '\n';
}

int main() {
    std::cout << "First 10 Fermat numbers:\n";
    for (unsigned int i = 0; i < 10; ++i)
        std::cout << "F(" << i << ") = " << fermat(i) << '\n';
    std::cout << "\nPrime factors:\n";
    for (unsigned int i = 0; i < 9; ++i) {
        std::cout << "F(" << i << "): ";
        print_vector(get_prime_factors(fermat(i)));
    }
    return 0;
}
