#include <chrono>
#include <iostream>
#include <locale>
#include <numeric>
#include <sstream>

#include <primesieve.hpp>

bool is_prime(uint64_t n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    if (n % 5 == 0)
        return n == 5;
    static constexpr uint64_t wheel[] = {4, 2, 4, 2, 4, 6, 2, 6};
    uint64_t p = 7;
    for (;;) {
        for (uint64_t w : wheel) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += w;
        }
    }
}

template <typename Iterator>
std::string join(Iterator begin, Iterator end, std::string_view separator) {
    std::ostringstream os;
    if (begin != end) {
        os << *begin++;
        for (; begin != end; ++begin)
            os << separator << *begin;
    }
    return os.str();
}

int main() {
    std::cout.imbue(std::locale(""));
    auto start = std::chrono::high_resolution_clock::now();
    std::vector<uint64_t> primes;
    uint64_t from = 0;
    for (uint64_t limit : {100, 5000, 10000, 500000, 50000000}) {
        primesieve::generate_primes(from, limit, &primes);
        from = limit + 1;
        uint64_t sum =
            std::accumulate(primes.begin(), primes.end(), uint64_t(0));
        size_t last = primes.size();
        size_t longest = 1;
        std::vector<std::pair<size_t, uint64_t>> starts;
        for (size_t start = 0; start <= last - longest; ++start) {
            uint64_t s = sum;
            for (size_t finish = last; finish-- >= start + longest;) {
                if (is_prime(s)) {
                    size_t length = finish - start + 1;
                    if (length > longest) {
                        longest = length;
                        starts.clear();
                    }
                    starts.emplace_back(start, s);
                }
                s -= primes[finish];
            }
            sum -= primes[start];
        }
        std::cout << "For primes up to " << limit << ":\n"
                  << "The following sequence" << (starts.size() == 1 ? "" : "s")
                  << " of " << longest << " consecutive primes yield"
                  << (starts.size() == 1 ? "s" : "") << " a prime sum:\n";
        for (auto [start, sum] : starts) {
            auto begin = primes.begin() + start;
            auto end = begin + longest;
            const char* separator = " + ";
            if (longest > 12) {
                std::cout << join(begin, begin + 6, separator) << separator
                          << "..." << separator
                          << join(end - 6, end, separator);
            } else {
                std::cout << join(begin, end, separator);
            }
            std::cout << " = " << sum << '\n';
        }
        std::cout << '\n';
    }
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration(end - start);
    std::cout << "Elapsed time: " << duration.count() << " seconds\n";
}
