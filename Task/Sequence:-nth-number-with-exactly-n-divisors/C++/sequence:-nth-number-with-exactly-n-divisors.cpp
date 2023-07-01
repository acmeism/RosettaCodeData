#include <iostream>
#include <vector>

std::vector<int> smallPrimes;

bool is_prime(size_t test) {
    if (test < 2) {
        return false;
    }
    if (test % 2 == 0) {
        return test == 2;
    }
    for (size_t d = 3; d * d <= test; d += 2) {
        if (test % d == 0) {
            return false;
        }
    }
    return true;
}

void init_small_primes(size_t numPrimes) {
    smallPrimes.push_back(2);

    int count = 0;
    for (size_t n = 3; count < numPrimes; n += 2) {
        if (is_prime(n)) {
            smallPrimes.push_back(n);
            count++;
        }
    }
}

size_t divisor_count(size_t n) {
    size_t count = 1;
    while (n % 2 == 0) {
        n /= 2;
        count++;
    }
    for (size_t d = 3; d * d <= n; d += 2) {
        size_t q = n / d;
        size_t r = n % d;
        size_t dc = 0;
        while (r == 0) {
            dc += count;
            n = q;
            q = n / d;
            r = n % d;
        }
        count += dc;
    }
    if (n != 1) {
        count *= 2;
    }
    return count;
}

uint64_t OEISA073916(size_t n) {
    if (is_prime(n)) {
        return (uint64_t) pow(smallPrimes[n - 1], n - 1);
    }

    size_t count = 0;
    uint64_t result = 0;
    for (size_t i = 1; count < n; i++) {
        if (n % 2 == 1) {
            //  The solution for an odd (non-prime) term is always a square number
            size_t root = (size_t) sqrt(i);
            if (root * root != i) {
                continue;
            }
        }
        if (divisor_count(i) == n) {
            count++;
            result = i;
        }
    }
    return result;
}

int main() {
    const int MAX = 15;
    init_small_primes(MAX);
    for (size_t n = 1; n <= MAX; n++) {
        if (n == 13) {
            std::cout << "A073916(" << n << ") = One more bit needed to represent result.\n";
        } else {
            std::cout << "A073916(" << n << ") = " << OEISA073916(n) << '\n';
        }
    }

    return 0;
}
