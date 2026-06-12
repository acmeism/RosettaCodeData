#include <iostream>
#include <locale>

#include <primesieve.hpp>

int main() {
    std::cout.imbue(std::locale(""));
    std::cout << "The 10,001st prime is " << primesieve::nth_prime(10001) << ".\n";
}
