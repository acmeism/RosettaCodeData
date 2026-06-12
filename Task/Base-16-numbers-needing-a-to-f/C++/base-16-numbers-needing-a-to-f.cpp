#include <iomanip>
#include <iostream>

// Returns true if the hexadecimal representation of n contains at least one
// non-decimal digit.
bool nondecimal(unsigned int n) {
    for (; n > 0; n >>= 4) {
        if ((n & 0xF) > 9)
            return true;
    }
    return false;
}

int main() {
    unsigned int count = 0;
    for (unsigned int n = 0; n < 501; ++n) {
        if (nondecimal(n)) {
            ++count;
            std::cout << std::setw(3) << n << (count % 15 == 0 ? '\n' : ' ');
        }
    }
    std::cout << "\n\n" << count << " such numbers found.\n";
}
