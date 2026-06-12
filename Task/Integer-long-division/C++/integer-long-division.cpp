#include <gmpxx.h>

#include <iomanip>
#include <iostream>
#include <map>
#include <string>

using big_int = mpz_class;

std::pair<std::string, size_t> divide(const big_int& n, const big_int& d) {
    assert(n >= 0);
    assert(d > 0);
    std::string result = big_int(n / d).get_str();
    result += '.';
    big_int c = 10 * (n % d);
    size_t digits = 0;
    std::map<big_int, size_t> seen;
    while (seen.count(c) == 0) {
        if (c == 0) {
            if (result.back() == '.')
                result.pop_back();
            return {result, 0};
        }
        seen[c] = digits++;
        if (c < d) {
            result += '0';
            c *= 10;
        } else {
            result += big_int(c / d).get_str();
            c = 10 * (c % d);
        }
    }
    return {result, digits - seen[c]};
}

int main() {
    big_int test[][2] = {
        {0, 1},   {1, 1},    {1, 5},
        {1, 3},   {1, 7},    {83, 60},
        {1, 17},  {10, 13},  {3227, 555},
        {1, 149}, {1, 5261}, {476837158203125, big_int("9223372036854775808")}};
    for (auto [n, d] : test) {
        auto [result, period] = divide(n, d);
        std::string str = n.get_str();
        str += '/';
        str += d.get_str();
        std::string repetend = result.substr(result.size() - period);
        if (repetend.size() > 30)
            repetend.replace(15, repetend.size() - 30, "...");
        result.resize(result.size() - period);
        std::cout << std::setw(35) << str << " = " << result;
        if (period != 0)
            std::cout << '{' << repetend << "} (period " << period << ')';
        std::cout << '\n';
    }
}
