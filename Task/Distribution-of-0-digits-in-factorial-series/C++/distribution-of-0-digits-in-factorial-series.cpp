#include <array>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <vector>

auto init_zc() {
    std::array<int, 1000> zc;
    zc.fill(0);
    zc[0] = 3;
    for (int x = 1; x <= 9; ++x) {
        zc[x] = 2;
        zc[10 * x] = 2;
        zc[100 * x] = 2;
        for (int y = 10; y <= 90; y += 10) {
            zc[y + x] = 1;
            zc[10 * y + x] = 1;
            zc[10 * (y + x)] = 1;
        }
    }
    return zc;
}

template <typename clock_type>
auto elapsed(const std::chrono::time_point<clock_type>& t0) {
    auto t1 = clock_type::now();
    auto duration =
        std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0);
    return duration.count();
}

int main() {
    auto zc = init_zc();
    auto t0 = std::chrono::high_resolution_clock::now();
    int trail = 1, first = 0;
    double total = 0;
    std::vector<int> rfs{1};
    std::cout << std::fixed << std::setprecision(10);
    for (int f = 2; f <= 50000; ++f) {
        int carry = 0, d999, zeroes = (trail - 1) * 3, len = rfs.size();
        for (int j = trail - 1; j < len || carry != 0; ++j) {
            if (j < len)
                carry += rfs[j] * f;
            d999 = carry % 1000;
            if (j < len)
                rfs[j] = d999;
            else
                rfs.push_back(d999);
            zeroes += zc[d999];
            carry /= 1000;
        }
        while (rfs[trail - 1] == 0)
            ++trail;
        d999 = rfs.back();
        d999 = d999 < 100 ? (d999 < 10 ? 2 : 1) : 0;
        zeroes -= d999;
        int digits = rfs.size() * 3 - d999;
        total += double(zeroes) / digits;
        double ratio = total / f;
        if (ratio >= 0.16)
            first = 0;
        else if (first == 0)
            first = f;
        if (f == 100 || f == 1000 || f == 10000) {
            std::cout << "Mean proportion of zero digits in factorials to " << f
                      << " is " << ratio << ". (" << elapsed(t0) << "ms)\n";
        }
    }
    std::cout << "The mean proportion dips permanently below 0.16 at " << first
              << ". (" << elapsed(t0) << "ms)\n";
}
