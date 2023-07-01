#include <algorithm>
#include <iostream>
#include <vector>

std::vector<uint64_t> primes;
std::vector<uint64_t> smallPrimes;

template <typename T>
std::ostream &operator <<(std::ostream &os, const std::vector<T> &v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << '[';

    if (it != end) {
        os << *it;
        it = std::next(it);
    }

    for (; it != end; it = std::next(it)) {
        os << ", " << *it;
    }

    return os << ']';
}

bool isPrime(uint64_t value) {
    if (value < 2) return false;

    if (value % 2 == 0) return value == 2;
    if (value % 3 == 0) return value == 3;

    if (value % 5 == 0) return value == 5;
    if (value % 7 == 0) return value == 7;

    if (value % 11 == 0) return value == 11;
    if (value % 13 == 0) return value == 13;

    if (value % 17 == 0) return value == 17;
    if (value % 19 == 0) return value == 19;

    if (value % 23 == 0) return value == 23;

    uint64_t t = 29;
    while (t * t < value) {
        if (value % t == 0) return false;
        value += 2;

        if (value % t == 0) return false;
        value += 4;
    }

    return true;
}

void init() {
    primes.push_back(2);
    smallPrimes.push_back(2);

    uint64_t i = 3;
    while (i <= 521) {
        if (isPrime(i)) {
            primes.push_back(i);
            if (i <= 29) {
                smallPrimes.push_back(i);
            }
        }
        i += 2;
    }
}

std::vector<uint64_t> nSmooth(uint64_t n, size_t size) {
    if (n < 2 || n>521) {
        throw std::runtime_error("n must be between 2 and 521");
    }
    if (size <= 1) {
        throw std::runtime_error("size must be at least 1");
    }

    uint64_t bn = n;
    if (primes.cend() == std::find(primes.cbegin(), primes.cend(), bn)) {
        throw std::runtime_error("n must be a prime number");
    }

    std::vector<uint64_t> ns(size, 0);
    ns[0] = 1;

    std::vector<uint64_t> next;
    for (auto prime : primes) {
        if (prime > bn) {
            break;
        }
        next.push_back(prime);
    }

    std::vector<size_t> indicies(next.size(), 0);
    for (size_t m = 1; m < size; m++) {
        ns[m] = *std::min_element(next.cbegin(), next.cend());
        for (size_t i = 0; i < indicies.size(); i++) {
            if (ns[m] == next[i]) {
                indicies[i]++;
                next[i] = primes[i] * ns[indicies[i]];
            }
        }
    }

    return ns;
}

int main() {
    init();

    for (auto i : smallPrimes) {
        std::cout << "The first " << i << "-smooth numbers are:\n";
        std::cout << nSmooth(i, 25) << '\n';
        std::cout << '\n';
    }

    // there is not enough bits to fully represent the 3-smooth numbers
    for (size_t i = 0; i < smallPrimes.size(); i++) {
        if (i < 1) continue;
        auto p = smallPrimes[i];

        auto v = nSmooth(p, 3002);
        v.erase(v.begin(), v.begin() + 2999);

        std::cout << "The 30,000th to 30,019th " << p << "-smooth numbers are:\n";
        std::cout << v << '\n';
        std::cout << '\n';
    }

    return 0;
}
