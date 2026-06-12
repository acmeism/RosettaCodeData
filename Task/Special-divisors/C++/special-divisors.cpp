#include <iostream>
#include <iomanip>
#include <vector>

using uint = unsigned int;

std::vector<uint> divisors(uint n) {
    std::vector<uint> divs;
    for (uint d=1; d<=n/2; d++) {
        if (n % d == 0) divs.push_back(d);
    }
    return divs;
}

uint reverse(uint n) {
    uint r;
    for (r = 0; n; n /= 10) r = (r*10) + (n%10);
    return r;
}

bool special(uint n) {
    for (uint d : divisors(n))
        if (reverse(n) % reverse(d) != 0) return false;
    return true;
}

int main() {
    for (uint n=1, c=0; n < 200; n++) {
        if (special(n)) {
            std::cout << std::setw(4) << n;
            if (++c == 10) {
                c = 0;
                std::cout << std::endl;
            }
        }
    }
    std::cout << std::endl;
    return 0;
}
