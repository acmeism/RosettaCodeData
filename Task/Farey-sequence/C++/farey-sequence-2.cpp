#include <iostream>
#include <list>
#include <utility>

struct farey_sequence: public std::list<std::pair<uint, uint>> {
    explicit farey_sequence(uint n) : order(n) {
        push_back(std::pair(0, 1));
        uint a = 0, b = 1, c = 1, d = n;
        while (c <= n) {
            const uint k = (n + b) / d;
            const uint next_c = k * c - a;
            const uint next_d = k * d - b;
            a = c;
            b = d;
            c = next_c;
            d = next_d;
            push_back(std::pair(a, b));
        }
    }

    const uint order;
};

std::ostream& operator<<(std::ostream &out, const farey_sequence &s) {
    out << s.order << ":";
    for (const auto &f : s)
        out << ' ' << f.first << '/' << f.second;
    return out;
}

int main() {
    for (uint i = 1u; i <= 11u; ++i)
        std::cout << farey_sequence(i) << std::endl;
    for (uint i = 100u; i <= 1000u; i += 100u) {
        const auto s = farey_sequence(i);
        std::cout << s.order << ": " << s.size() << " items" << std::endl;
    }

    return EXIT_SUCCESS;
}
