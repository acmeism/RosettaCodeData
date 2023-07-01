#include <algorithm>
#include <cassert>
#include <iomanip>
#include <iostream>
#include <map>
#include <vector>

#include <primesieve.hpp>

class erdos_selfridge {
public:
    explicit erdos_selfridge(int limit);
    uint64_t get_prime(int index) const { return primes_[index].first; }
    int get_category(int index);

private:
    std::vector<std::pair<uint64_t, int>> primes_;
    size_t get_index(uint64_t prime) const;
};

erdos_selfridge::erdos_selfridge(int limit) {
    primesieve::iterator iter;
    for (int i = 0; i < limit; ++i)
        primes_.emplace_back(iter.next_prime(), 0);
}

int erdos_selfridge::get_category(int index) {
    auto& pair = primes_[index];
    if (pair.second != 0)
        return pair.second;
    int max_category = 0;
    uint64_t n = pair.first + 1;
    for (int i = 0; n > 1; ++i) {
        uint64_t p = primes_[i].first;
        if (p * p > n)
            break;
        int count = 0;
        for (; n % p == 0; ++count)
            n /= p;
        if (count != 0) {
            int category = (p <= 3) ? 1 : 1 + get_category(i);
            max_category = std::max(max_category, category);
        }
    }
    if (n > 1) {
        int category = (n <= 3) ? 1 : 1 + get_category(get_index(n));
        max_category = std::max(max_category, category);
    }
    pair.second = max_category;
    return max_category;
}

size_t erdos_selfridge::get_index(uint64_t prime) const {
    auto it = std::lower_bound(primes_.begin(), primes_.end(), prime,
                               [](const std::pair<uint64_t, int>& p,
                                  uint64_t n) { return p.first < n; });
    assert(it != primes_.end());
    assert(it->first == prime);
    return std::distance(primes_.begin(), it);
}

auto get_primes_by_category(erdos_selfridge& es, int limit) {
    std::map<int, std::vector<uint64_t>> primes_by_category;
    for (int i = 0; i < limit; ++i) {
        uint64_t prime = es.get_prime(i);
        int category = es.get_category(i);
        primes_by_category[category].push_back(prime);
    }
    return primes_by_category;
}

int main() {
    const int limit1 = 200, limit2 = 1000000;

    erdos_selfridge es(limit2);

    std::cout << "First 200 primes:\n";
    for (const auto& p : get_primes_by_category(es, limit1)) {
        std::cout << "Category " << p.first << ":\n";
        for (size_t i = 0, n = p.second.size(); i != n; ++i) {
            std::cout << std::setw(4) << p.second[i]
                      << ((i + 1) % 15 == 0 ? '\n' : ' ');
        }
        std::cout << "\n\n";
    }

    std::cout << "First 1,000,000 primes:\n";
    for (const auto& p : get_primes_by_category(es, limit2)) {
        const auto& v = p.second;
        std::cout << "Category " << std::setw(2) << p.first << ": "
                  << "first = " << std::setw(7) << v.front()
                  << "  last = " << std::setw(8) << v.back()
                  << "  count = " << v.size() << '\n';
    }
}
