#include <iostream>
#include <map>
#include <vector>
#include <gmpxx.h>

using integer = mpz_class;

integer reverse(integer n) {
    integer rev = 0;
    while (n > 0) {
        rev = rev * 10 + (n % 10);
        n /= 10;
    }
    return rev;
}

void print_vector(const std::vector<integer>& vec) {
    if (vec.empty())
        return;
    auto i = vec.begin();
    std::cout << *i++;
    for (; i != vec.end(); ++i)
        std::cout << ", " << *i;
    std::cout << '\n';
}

int main() {
    std::map<integer, std::pair<bool, integer>> cache;
    std::vector<integer> seeds, related, palindromes;
    for (integer n = 1; n <= 10000; ++n) {
        std::pair<bool, integer> p(true, n);
        std::vector<integer> seen;
        integer rev = reverse(n);
        integer sum = n;
        for (int i = 0; i < 500; ++i) {
            sum += rev;
            rev = reverse(sum);
            if (rev == sum) {
                p.first = false;
                p.second = 0;
                break;
            }
            auto iter = cache.find(sum);
            if (iter != cache.end()) {
                p = iter->second;
                break;
            }
            seen.push_back(sum);
        }
        for (integer s : seen)
            cache.emplace(s, p);
        if (!p.first)
            continue;
        if (p.second == n)
            seeds.push_back(n);
        else
            related.push_back(n);
        if (n == reverse(n))
            palindromes.push_back(n);
    }
    std::cout << "number of seeds: " << seeds.size() << '\n';
    std::cout << "seeds: ";
    print_vector(seeds);
    std::cout << "number of related: " << related.size() << '\n';
    std::cout << "palindromes: ";
    print_vector(palindromes);
    return 0;
}
