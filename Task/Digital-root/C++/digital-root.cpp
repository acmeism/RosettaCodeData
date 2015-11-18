// Calculate the Digital Root and Additive Persistance of an Integer - Compiles with gcc4.7
//
// Nigel Galloway. July 23rd., 2012
//
#include <iostream>
#include <cmath>
#include <utility>

template<class P_> P_ IncFirst(const P_& src) {return P_(src.first + 1, src.second);}

std::pair<int, int> DigitalRoot(unsigned long long digits, int base = 10)
{
    int x = SumDigits(digits, base);
    return x < base ? std::make_pair(1, x) : IncFirst(DigitalRoot(x, base));  // x is implicitly converted to unsigned long long; this is lossless
}

int main() {
    const unsigned long long ip[] = {961038,923594037444,670033,448944221089};
    for (auto i:ip){
        auto res = DigitalRoot(i);
        std::cout << i << " has digital root " << res.second << " and additive persistance " << res.first << "\n";
    }
    std::cout << "\n";
    const unsigned long long hip[] = {0x7e0,0x14e344,0xd60141,0x12343210};
    for (auto i:hip){
        auto res = DigitalRoot(i,16);
        std::cout << std::hex << i << " has digital root " << res.second << " and additive persistance " << res.first << "\n";
    }
    return 0;
}
