#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include "prime_sieve.hpp"

int main(int argc, char** argv) {
    const char* filename(argc < 2 ? "unixdict.txt" : argv[1]);
    std::ifstream in(filename);
    if (!in) {
        std::cerr << "Cannot open file '" << filename << "'.\n";
        return EXIT_FAILURE;
    }
    std::string line;
    prime_sieve sieve(UCHAR_MAX);
    auto is_prime = [&sieve](unsigned char c){ return sieve.is_prime(c); };
    int n = 0;
    while (getline(in, line)) {
        if (std::all_of(line.begin(), line.end(), is_prime)) {
            ++n;
            std::cout << std::right << std::setw(2) << n << ": "
                << std::left << std::setw(10) << line;
            if (n % 4 == 0)
                std::cout << '\n';
        }
    }
    return EXIT_SUCCESS;
}
