#include <cmath>
#include <iostream>
#include <tuple>
#include <vector>

using triple = std::tuple<int, int, int>;

void print_triple(std::ostream& out, const triple& t) {
    out << '(' << std::get<0>(t) << ',' << std::get<1>(t) << ',' << std::get<2>(t) << ')';
}

void print_vector(std::ostream& out, const std::vector<triple>& vec) {
    if (vec.empty())
        return;
    auto i = vec.begin();
    print_triple(out, *i++);
    for (; i != vec.end(); ++i) {
        out << ' ';
        print_triple(out, *i);
    }
    out << "\n\n";
}

int isqrt(int n) {
    return static_cast<int>(std::sqrt(n));
}

int main() {
    const int min = 1, max = 13;
    std::vector<triple> solutions90, solutions60, solutions120;

    for (int a = min; a <= max; ++a) {
        int a2 = a * a;
        for (int b = a; b <= max; ++b) {
            int b2 = b * b, ab = a * b;
            int c2 = a2 + b2;
            int c = isqrt(c2);
            if (c <= max && c * c == c2)
                solutions90.emplace_back(a, b, c);
            else {
                c2 = a2 + b2 - ab;
                c = isqrt(c2);
                if (c <= max && c * c == c2)
                    solutions60.emplace_back(a, b, c);
                else {
                    c2 = a2 + b2 + ab;
                    c = isqrt(c2);
                    if (c <= max && c * c == c2)
                        solutions120.emplace_back(a, b, c);
                }
            }
        }
    }

    std::cout << "There are " << solutions60.size() << " solutions for gamma = 60 degrees:\n";
    print_vector(std::cout, solutions60);

    std::cout << "There are " << solutions90.size() << " solutions for gamma = 90 degrees:\n";
    print_vector(std::cout, solutions90);

    std::cout << "There are " << solutions120.size() << " solutions for gamma = 120 degrees:\n";
    print_vector(std::cout, solutions120);

    const int max2 = 10000;
    int count = 0;
    for (int a = min; a <= max2; ++a) {
        for (int b = a + 1; b <= max2; ++b) {
            int c2 = a * a + b * b - a * b;
            int c = isqrt(c2);
            if (c <= max2 && c * c == c2)
                ++count;
        }
    }
    std::cout << "There are " << count << " solutions for gamma = 60 degrees in the range "
        << min << " to " << max2 << " where the sides are not all of the same length.\n";
    return 0;
}
