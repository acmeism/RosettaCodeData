// Reference: https://en.wikipedia.org/wiki/Lah_number#Identities_and_relations

#include <algorithm>
#include <iomanip>
#include <iostream>
#include <map>
#include <gmpxx.h>

using integer = mpz_class;

class unsigned_lah_numbers {
public:
    integer get(int n, int k);
private:
    std::map<std::pair<int, int>, integer> cache_;
};

integer unsigned_lah_numbers::get(int n, int k) {
    if (k == n)
        return 1;
    if (k == 0 || k > n)
        return 0;
    auto p = std::make_pair(n, k);
    auto i = cache_.find(p);
    if (i != cache_.end())
        return i->second;
    integer result = (n - 1 + k) * get(n - 1, k) + get(n - 1, k - 1);
    cache_.emplace(p, result);
    return result;
}

void print_lah_numbers(unsigned_lah_numbers& uln, int n) {
    std::cout << "Unsigned Lah numbers up to L(12,12):\nn/k";
    for (int j = 1; j <= n; ++j)
        std::cout << std::setw(11) << j;
    std::cout << '\n';
    for (int i = 1; i <= n; ++i) {
        std::cout << std::setw(2) << i << ' ';
        for (int j = 1; j <= i; ++j)
            std::cout << std::setw(11) << uln.get(i, j);
        std::cout << '\n';
    }
}

int main() {
    unsigned_lah_numbers uln;
    print_lah_numbers(uln, 12);
    std::cout << "Maximum value of L(n,k) where n == 100:\n";
    integer max = 0;
    for (int k = 0; k <= 100; ++k)
        max = std::max(max, uln.get(100, k));
    std::cout << max << '\n';
    return 0;
}
