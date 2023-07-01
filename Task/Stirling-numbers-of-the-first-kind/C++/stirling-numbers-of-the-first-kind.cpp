#include <algorithm>
#include <iomanip>
#include <iostream>
#include <map>
#include <gmpxx.h>

using integer = mpz_class;

class unsigned_stirling1 {
public:
    integer get(int n, int k);
private:
    std::map<std::pair<int, int>, integer> cache_;
};

integer unsigned_stirling1::get(int n, int k) {
    if (k == 0)
        return n == 0 ? 1 : 0;
    if (k > n)
        return 0;
    auto p = std::make_pair(n, k);
    auto i = cache_.find(p);
    if (i != cache_.end())
        return i->second;
    integer s = get(n - 1, k - 1) + (n - 1) * get(n - 1, k);
    cache_.emplace(p, s);
    return s;
}

void print_stirling_numbers(unsigned_stirling1& s1, int n) {
    std::cout << "Unsigned Stirling numbers of the first kind:\nn/k";
    for (int j = 0; j <= n; ++j) {
        std::cout << std::setw(j == 0 ? 2 : 10) << j;
    }
    std::cout << '\n';
    for (int i = 0; i <= n; ++i) {
        std::cout << std::setw(2) << i << ' ';
        for (int j = 0; j <= i; ++j)
            std::cout << std::setw(j == 0 ? 2 : 10) << s1.get(i, j);
        std::cout << '\n';
    }
}

int main() {
    unsigned_stirling1 s1;
    print_stirling_numbers(s1, 12);
    std::cout << "Maximum value of S1(n,k) where n == 100:\n";
    integer max = 0;
    for (int k = 0; k <= 100; ++k)
        max = std::max(max, s1.get(100, k));
    std::cout << max << '\n';
    return 0;
}
