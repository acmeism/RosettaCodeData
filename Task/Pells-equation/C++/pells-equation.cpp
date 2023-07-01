#include <iomanip>
#include <iostream>
#include <tuple>

std::tuple<uint64_t, uint64_t> solvePell(int n) {
    int x = (int)sqrt(n);

    if (x * x == n) {
        // n is a perfect square - no solution other than 1,0
        return std::make_pair(1, 0);
    }

    // there are non-trivial solutions
    int y = x;
    int z = 1;
    int r = 2 * x;
    std::tuple<uint64_t, uint64_t> e = std::make_pair(1, 0);
    std::tuple<uint64_t, uint64_t> f = std::make_pair(0, 1);
    uint64_t a = 0;
    uint64_t b = 0;

    while (true) {
        y = r * z - y;
        z = (n - y * y) / z;
        r = (x + y) / z;
        e = std::make_pair(std::get<1>(e), r * std::get<1>(e) + std::get<0>(e));
        f = std::make_pair(std::get<1>(f), r * std::get<1>(f) + std::get<0>(f));
        a = std::get<1>(e) + x * std::get<1>(f);
        b = std::get<1>(f);
        if (a * a - n * b * b == 1) {
            break;
        }
    }

    return std::make_pair(a, b);
}

void test(int n) {
    auto r = solvePell(n);
    std::cout << "x^2 - " << std::setw(3) << n << " * y^2 = 1 for x = " << std::setw(21) << std::get<0>(r) << " and y = " << std::setw(21) << std::get<1>(r) << '\n';
}

int main() {
    test(61);
    test(109);
    test(181);
    test(277);

    return 0;
}
