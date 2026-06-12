#include <array>
#include <iostream>
#include <map>
#include <vector>

#include <primesieve.hpp>

using digit_set = std::array<int, 10>;

digit_set get_digits(uint64_t n) {
    digit_set result = {};
    for (; n > 0; n /= 10)
        ++result[n % 10];
    return result;
}

int main() {
    std::cout.imbue(std::locale(""));
    primesieve::iterator pi;
    using map_type =
        std::map<digit_set, std::vector<uint64_t>, std::greater<digit_set>>;
    map_type anaprimes;
    for (uint64_t limit = 1000; limit <= 10000000000;) {
        uint64_t prime = pi.next_prime();
        if (prime > limit) {
            size_t max_length = 0;
            std::vector<map_type::iterator> groups;
            for (auto i = anaprimes.begin(); i != anaprimes.end(); ++i) {
                if (i->second.size() > max_length) {
                    groups.clear();
                    max_length = i->second.size();
                }
                if (max_length == i->second.size())
                    groups.push_back(i);
            }
            std::cout << "Largest group(s) of anaprimes before " << limit
                      << ": " << max_length << " members:\n";
            for (auto i : groups) {
                std::cout << "  First: " << i->second.front()
                          << "  Last: " << i->second.back() << '\n';
            }
            std::cout << '\n';
            anaprimes.clear();
            limit *= 10;
        }
        anaprimes[get_digits(prime)].push_back(prime);
    }
}
