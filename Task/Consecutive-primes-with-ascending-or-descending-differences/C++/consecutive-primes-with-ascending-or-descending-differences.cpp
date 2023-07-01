#include <cstdint>
#include <iostream>
#include <vector>
#include <primesieve.hpp>

void print_diffs(const std::vector<uint64_t>& vec) {
    for (size_t i = 0, n = vec.size(); i != n; ++i) {
        if (i != 0)
            std::cout << " (" << vec[i] - vec[i - 1] << ") ";
        std::cout << vec[i];
    }
    std::cout << '\n';
}

int main() {
    std::cout.imbue(std::locale(""));
    std::vector<uint64_t> asc, desc;
    std::vector<std::vector<uint64_t>> max_asc, max_desc;
    size_t max_asc_len = 0, max_desc_len = 0;
    uint64_t prime;
    const uint64_t limit = 1000000;
    for (primesieve::iterator pi; (prime = pi.next_prime()) < limit; ) {
        size_t alen = asc.size();
        if (alen > 1 && prime - asc[alen - 1] <= asc[alen - 1] - asc[alen - 2])
            asc.erase(asc.begin(), asc.end() - 1);
        asc.push_back(prime);
        if (asc.size() >= max_asc_len) {
            if (asc.size() > max_asc_len) {
                max_asc_len = asc.size();
                max_asc.clear();
            }
            max_asc.push_back(asc);
        }
        size_t dlen = desc.size();
        if (dlen > 1 && prime - desc[dlen - 1] >= desc[dlen - 1] - desc[dlen - 2])
            desc.erase(desc.begin(), desc.end() - 1);
        desc.push_back(prime);
        if (desc.size() >= max_desc_len) {
            if (desc.size() > max_desc_len) {
                max_desc_len = desc.size();
                max_desc.clear();
            }
            max_desc.push_back(desc);
        }
    }
    std::cout << "Longest run(s) of ascending prime gaps up to " << limit << ":\n";
    for (const auto& v : max_asc)
        print_diffs(v);
    std::cout << "\nLongest run(s) of descending prime gaps up to " << limit << ":\n";
    for (const auto& v : max_desc)
        print_diffs(v);
    return 0;
}
