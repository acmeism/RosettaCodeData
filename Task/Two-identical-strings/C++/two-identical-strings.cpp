#include <iostream>
#include <string>

// Given the base 2 representation of a number n, transform it into the base 2
// representation of n + 1.
void base2_increment(std::string& s) {
    size_t z = s.rfind('0');
    if (z != std::string::npos) {
        s[z] = '1';
        size_t count = s.size() - (z + 1);
        s.replace(z + 1, count, count, '0');
    } else {
        s.assign(s.size() + 1, '0');
        s[0] = '1';
    }
}

int main() {
    std::cout << "Decimal\tBinary\n";
    std::string s("1");
    for (unsigned int n = 1; ; ++n) {
        unsigned int i = n + (n << s.size());
        if (i >= 1000)
            break;
        std::cout << i << '\t' << s << s << '\n';
        base2_increment(s);
    }
}
