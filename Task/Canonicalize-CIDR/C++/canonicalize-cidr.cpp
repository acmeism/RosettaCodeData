#include <cstdint>
#include <iomanip>
#include <iostream>
#include <sstream>

// Class representing an IPv4 address + netmask length
class ipv4_cidr {
public:
    ipv4_cidr() {}
    ipv4_cidr(std::uint32_t address, unsigned int mask_length)
        : address_(address), mask_length_(mask_length) {}
    std::uint32_t address() const {
        return address_;
    }
    unsigned int mask_length() const {
        return mask_length_;
    }
    friend std::istream& operator>>(std::istream&, ipv4_cidr&);
private:
    std::uint32_t address_ = 0;
    unsigned int mask_length_ = 0;
};

// Stream extraction operator, also performs canonicalization
std::istream& operator>>(std::istream& in, ipv4_cidr& cidr) {
    int a, b, c, d, m;
    char ch;
    if (!(in >> a >> ch) || a < 0 || a > UINT8_MAX || ch != '.'
        || !(in >> b >> ch) || b < 0 || b > UINT8_MAX || ch != '.'
        || !(in >> c >> ch) || c < 0 || c > UINT8_MAX || ch != '.'
        || !(in >> d >> ch) || d < 0 || d > UINT8_MAX || ch != '/'
        || !(in >> m) || m < 1 || m > 32) {
        in.setstate(std::ios_base::failbit);
        return in;
    }
    uint32_t mask = ~((1 << (32 - m)) - 1);
    uint32_t address = (a << 24) + (b << 16) + (c << 8) + d;
    address &= mask;
    cidr.address_ = address;
    cidr.mask_length_ = m;
    return in;
}

// Stream insertion operator
std::ostream& operator<<(std::ostream& out, const ipv4_cidr& cidr) {
    uint32_t address = cidr.address();
    unsigned int d = address & UINT8_MAX;
    address >>= 8;
    unsigned int c = address & UINT8_MAX;
    address >>= 8;
    unsigned int b = address & UINT8_MAX;
    address >>= 8;
    unsigned int a = address & UINT8_MAX;
    out << a << '.' << b << '.' << c << '.' << d << '/'
        << cidr.mask_length();
    return out;
}

int main(int argc, char** argv) {
    const char* tests[] = {
        "87.70.141.1/22",
        "36.18.154.103/12",
        "62.62.197.11/29",
        "67.137.119.181/4",
        "161.214.74.21/24",
        "184.232.176.184/18"
    };
    for (auto test : tests) {
        std::istringstream in(test);
        ipv4_cidr cidr;
        if (in >> cidr)
            std::cout << std::setw(18) << std::left << test << " -> "
                << cidr << '\n';
        else
            std::cerr << test << ": invalid CIDR\n";
    }
    return 0;
}
