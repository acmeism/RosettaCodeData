#include <algorithm>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <locale>
#include <vector>

#include <primesieve.hpp>

auto get_primes_by_digits(uint64_t limit) {
    primesieve::iterator pi;
    std::vector<std::vector<uint64_t>> primes_by_digits;
    std::vector<uint64_t> primes;
    for (uint64_t p = 10; p <= limit;) {
        uint64_t prime = pi.next_prime();
        if (prime > p) {
            primes_by_digits.push_back(std::move(primes));
            p *= 10;
        }
        primes.push_back(prime);
    }
    return primes_by_digits;
}

int main() {
    std::cout.imbue(std::locale(""));

    auto start = std::chrono::high_resolution_clock::now();

    auto primes_by_digits = get_primes_by_digits(1000000000);

    std::cout << "First 100 brilliant numbers:\n";
    std::vector<uint64_t> brilliant_numbers;
    for (const auto& primes : primes_by_digits) {
        for (auto i = primes.begin(); i != primes.end(); ++i)
            for (auto j = i; j != primes.end(); ++j)
                brilliant_numbers.push_back(*i * *j);
        if (brilliant_numbers.size() >= 100)
            break;
    }
    std::sort(brilliant_numbers.begin(), brilliant_numbers.end());
    for (size_t i = 0; i < 100; ++i) {
        std::cout << std::setw(5) << brilliant_numbers[i]
                  << ((i + 1) % 10 == 0 ? '\n' : ' ');
    }

    std::cout << '\n';
    uint64_t power = 10;
    size_t count = 0;
    for (size_t p = 1; p < 2 * primes_by_digits.size(); ++p) {
        const auto& primes = primes_by_digits[p / 2];
        size_t position = count + 1;
        uint64_t min_product = 0;
        for (auto i = primes.begin(); i != primes.end(); ++i) {
            uint64_t p1 = *i;
            auto j = std::lower_bound(i, primes.end(), (power + p1 - 1) / p1);
            if (j != primes.end()) {
                uint64_t p2 = *j;
                uint64_t product = p1 * p2;
                if (min_product == 0 || product < min_product)
                    min_product = product;
                position += std::distance(i, j);
                if (p1 >= p2)
                    break;
            }
        }
        std::cout << "First brilliant number >= 10^" << p << " is "
                  << min_product << " at position " << position << '\n';
        power *= 10;
        if (p % 2 == 1) {
            size_t size = primes.size();
            count += size * (size + 1) / 2;
        }
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration(end - start);
    std::cout << "\nElapsed time: " << duration.count() << " seconds\n";
}
