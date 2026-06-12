#include <iostream>
#include <iomanip>
#include <string>
#include <gmpxx.h>

std::string smallest_six(unsigned int n) {
    mpz_class pow = 1;
    std::string goal = std::to_string(n);

    while (pow.get_str().find(goal) == std::string::npos) {
        pow *= 6;
    }

    return pow.get_str();
}

int main() {
    for (unsigned int i=0; i<22; i++) {
        std::cout << std::setw(2) << i << ": "
                  << smallest_six(i) << std::endl;
    }
    return 0;
}
