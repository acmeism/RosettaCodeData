#include <iostream>
#include <locale>
#include <unordered_map>

#include <primesieve.hpp>

class prime_gaps {
public:
    prime_gaps() { last_prime_ = iterator_.next_prime(); }
    uint64_t find_gap_start(uint64_t gap);
private:
    primesieve::iterator iterator_;
    uint64_t last_prime_;
    std::unordered_map<uint64_t, uint64_t> gap_starts_;
};

uint64_t prime_gaps::find_gap_start(uint64_t gap) {
    auto i = gap_starts_.find(gap);
    if (i != gap_starts_.end())
        return i->second;
    for (;;) {
        uint64_t prev = last_prime_;
        last_prime_ = iterator_.next_prime();
        uint64_t diff = last_prime_ - prev;
        gap_starts_.emplace(diff, prev);
        if (gap == diff)
            return prev;
    }
}

int main() {
    std::cout.imbue(std::locale(""));
    const uint64_t limit = 100000000000;
    prime_gaps pg;
    for (uint64_t pm = 10, gap1 = 2;;) {
        uint64_t start1 = pg.find_gap_start(gap1);
        uint64_t gap2 = gap1 + 2;
        uint64_t start2 = pg.find_gap_start(gap2);
        uint64_t diff = start2 > start1 ? start2 - start1 : start1 - start2;
        if (diff > pm) {
            std::cout << "Earliest difference > " << pm
                      << " between adjacent prime gap starting primes:\n"
                      << "Gap " << gap1 << " starts at " << start1 << ", gap "
                      << gap2 << " starts at " << start2 << ", difference is "
                      << diff << ".\n\n";
            if (pm == limit)
                break;
            pm *= 10;
        } else {
            gap1 = gap2;
        }
    }
}
