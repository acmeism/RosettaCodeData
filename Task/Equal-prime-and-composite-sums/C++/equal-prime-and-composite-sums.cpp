#include <primesieve.hpp>

#include <chrono>
#include <iomanip>
#include <iostream>
#include <locale>

class composite_iterator {
public:
    composite_iterator();
    uint64_t next_composite();

private:
    uint64_t composite;
    uint64_t prime;
    primesieve::iterator pi;
};

composite_iterator::composite_iterator() {
    composite = prime = pi.next_prime();
    for (; composite == prime; ++composite)
        prime = pi.next_prime();
}

uint64_t composite_iterator::next_composite() {
    uint64_t result = composite;
    while (++composite == prime)
        prime = pi.next_prime();
    return result;
}

int main() {
    std::cout.imbue(std::locale(""));
    auto start = std::chrono::high_resolution_clock::now();
    composite_iterator ci;
    primesieve::iterator pi;
    uint64_t prime_sum = pi.next_prime();
    uint64_t composite_sum = ci.next_composite();
    uint64_t prime_index = 1, composite_index = 1;
    std::cout << "Sum                   | Prime Index  | Composite Index\n";
    std::cout << "------------------------------------------------------\n";
    for (int count = 0; count < 11;) {
        if (prime_sum == composite_sum) {
            std::cout << std::right << std::setw(21) << prime_sum << " | "
                      << std::setw(12) << prime_index << " | " << std::setw(15)
                      << composite_index << '\n';
            composite_sum += ci.next_composite();
            prime_sum += pi.next_prime();
            ++prime_index;
            ++composite_index;
            ++count;
        } else if (prime_sum < composite_sum) {
            prime_sum += pi.next_prime();
            ++prime_index;
        } else {
            composite_sum += ci.next_composite();
            ++composite_index;
        }
    }
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration(end - start);
    std::cout << "\nElapsed time: " << duration.count() << " seconds\n";
}
