#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <primesieve.hpp>

void compute_transitions(uint64_t limit) {
    primesieve::iterator it;
    std::map<std::pair<uint64_t, uint64_t>, uint64_t> transitions;
    for (uint64_t count = 0, prev = 0; count < limit; ++count) {
        uint64_t prime = it.next_prime();
        uint64_t digit = prime % 10;
        if (prev != 0)
            ++transitions[std::make_pair(prev, digit)];
        prev = digit;
    }
    std::cout << "First " << limit << " prime numbers:\n";
    for (auto&& pair : transitions) {
        double freq = (100.0 * pair.second)/limit;
        std::cout << pair.first.first << " -> " << pair.first.second
            << ": count = " << std::setw(7) << pair.second
            << ", frequency = " << std::setprecision(2)
            << std::fixed << freq << " %\n";
    }
}

int main(int argc, const char * argv[]) {
    compute_transitions(1000000);
    compute_transitions(100000000);
    return 0;
}
