#include <cmath>
#include <iostream>
#include <vector>

std::vector<int> generate_primes(int limit) {
    std::vector<bool> sieve(limit >> 1, true);
    for (int p = 3, s = 9; s < limit; p += 2) {
        if (sieve[p >> 1]) {
            for (int q = s; q < limit; q += p << 1)
                sieve[q >> 1] = false;
        }
        s += (p + 1) << 2;
    }
    std::vector<int> primes;
    if (limit > 2)
        primes.push_back(2);
    for (int i = 1; i < sieve.size(); ++i) {
        if (sieve[i])
            primes.push_back((i << 1) + 1);
    }
    return primes;
}

class legendre_prime_counter {
public:
    explicit legendre_prime_counter(int limit);
    int prime_count(int n);
private:
    int phi(int x, int a);
    std::vector<int> primes;
};

legendre_prime_counter::legendre_prime_counter(int limit) :
    primes(generate_primes(static_cast<int>(std::sqrt(limit)))) {}

int legendre_prime_counter::prime_count(int n) {
    if (n < 2)
        return 0;
    int a = prime_count(static_cast<int>(std::sqrt(n)));
    return phi(n, a) + a - 1;
}

int legendre_prime_counter::phi(int x, int a) {
    if (a == 0)
        return x;
    if (a == 1)
        return x - (x >> 1);
    int pa = primes[a - 1];
    if (x <= pa)
        return 1;
    return phi(x, a - 1) - phi(x / pa, a - 1);
}

int main() {
    legendre_prime_counter counter(1000000000);
    for (int i = 0, n = 1; i < 10; ++i, n *= 10)
        std::cout << "10^" << i << "\t" << counter.prime_count(n) << '\n';
}
