#include <algorithm>
#include <iomanip>
#include <iostream>
#include <map>
#include <gmpxx.h>

using integer = mpz_class;

class stirling2 {
public:
    integer get(int n, int k);
private:
    std::map<std::pair<int, int>, integer> cache_;
};

integer stirling2::get(int n, int k) {
    if (k == n)
        return 1;
    if (k == 0 || k > n)
        return 0;
    auto p = std::make_pair(n, k);
    auto i = cache_.find(p);
    if (i != cache_.end())
        return i->second;
    integer s = k * get(n - 1, k) + get(n - 1, k - 1);
    cache_.emplace(p, s);
    return s;
}

void print_stirling_numbers(stirling2& s2, int n) {
    std::cout << "Stirling numbers of the second kind:\nn/k";
    for (int j = 0; j <= n; ++j) {
        std::cout << std::setw(j == 0 ? 2 : 8) << j;
    }
    std::cout << '\n';
    for (int i = 0; i <= n; ++i) {
        std::cout << std::setw(2) << i << ' ';
        for (int j = 0; j <= i; ++j)
            std::cout << std::setw(j == 0 ? 2 : 8) << s2.get(i, j);
        std::cout << '\n';
    }
}

int main() {
    stirling2 s2;
    print_stirling_numbers(s2, 12);
    std::cout << "Maximum value of S2(n,k) where n == 100:\n";
    integer max = 0;
    for (int k = 0; k <= 100; ++k)
        max = std::max(max, s2.get(100, k));
    std::cout << max << '\n';
    return 0;
}
