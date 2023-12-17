#include <cstdint>
#include <iostream>
#include <string>
#include <primesieve.hpp>

void print_twin_prime_count(long long limit) {
    std::cout << "Number of twin prime pairs less than " << limit
        << " is " << (limit > 0 ? primesieve::count_twins(0, limit - 1) : 0) << '\n';
}

int main(int argc, char** argv) {
    std::cout.imbue(std::locale(""));
    if (argc > 1) {
        // print number of twin prime pairs less than limits specified
        // on the command line
        for (int i = 1; i < argc; ++i) {
            try {
                print_twin_prime_count(std::stoll(argv[i]));
            } catch (const std::exception& ex) {
                std::cerr << "Cannot parse limit from '" << argv[i] << "'\n";
            }
        }
    } else {
        // if no limit was specified then show the number of twin prime
        // pairs less than powers of 10 up to 100 billion
        uint64_t limit = 10;
        for (int power = 1; power < 12; ++power, limit *= 10)
            print_twin_prime_count(limit);
    }
    return 0;
}
