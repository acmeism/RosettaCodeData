#include <iostream>
#include <iomanip>
#include <bitset>

const int LIMIT = 100000;

std::bitset<16> digitset(int num, int base) {
    std::bitset<16> set;
    for (; num; num /= base) set.set(num % base);
    return set;
}

int main() {
    int c = 0;
    for (int i=0; i<LIMIT; i++) {
        if (digitset(i,10) == digitset(i,16)) {
            std::cout << std::setw(7) << i;
            if (++c % 10 == 0) std::cout << std::endl;
        }
    }
    std::cout << std::endl;
    return 0;
}
