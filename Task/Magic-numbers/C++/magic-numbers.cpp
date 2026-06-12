#include <array>
#include <iostream>
#include <numeric>
#include <vector>

#include <boost/multiprecision/cpp_int.hpp>

using boost::multiprecision::uint128_t;

class magic_number_generator {
public:
    magic_number_generator() : magic_(10) {
        std::iota(magic_.begin(), magic_.end(), 0);
    }
    bool next(uint128_t& n);

public:
    std::vector<uint128_t> magic_;
    size_t index_ = 0;
    int digits_ = 2;
};

bool magic_number_generator::next(uint128_t& n) {
    if (index_ == magic_.size()) {
        std::vector<uint128_t> magic;
        for (uint128_t m : magic_) {
            if (m == 0)
                continue;
            uint128_t n = 10 * m;
            for (int d = 0; d < 10; ++d, ++n) {
                if (n % digits_ == 0)
                    magic.push_back(n);
            }
        }
        index_ = 0;
        ++digits_;
        magic_ = std::move(magic);
    }
    if (magic_.empty())
        return false;
    n = magic_[index_++];
    return true;
}

std::array<int, 10> get_digits(uint128_t n) {
    std::array<int, 10> result = {};
    for (; n > 0; n /= 10)
        ++result[static_cast<int>(n % 10)];
    return result;
}

int main() {
    int count = 0, dcount = 0;
    uint128_t magic = 0, p = 10;
    std::vector<int> digit_count;

    std::array<int, 10> digits0 = {1,1,1,1,1,1,1,1,1,1};
    std::array<int, 10> digits1 = {0,1,1,1,1,1,1,1,1,1};
    std::vector<uint128_t> pandigital0, pandigital1;

    for (magic_number_generator gen; gen.next(magic);) {
        if (magic >= p) {
            p *= 10;
            digit_count.push_back(dcount);
            dcount = 0;
        }
        auto digits = get_digits(magic);
        if (digits == digits0)
            pandigital0.push_back(magic);
        else if (digits == digits1)
            pandigital1.push_back(magic);
        ++count;
        ++dcount;
    }
    digit_count.push_back(dcount);

    std::cout << "There are " << count << " magic numbers.\n\n";
    std::cout << "The largest magic number is " << magic << ".\n\n";

    std::cout << "Magic number count by digits:\n";
    for (int i = 0; i < digit_count.size(); ++i)
        std::cout << i + 1 << '\t' << digit_count[i] << '\n';

    std::cout << "\nMagic numbers that are minimally pandigital in 1-9:\n";
    for (auto m : pandigital1)
        std::cout << m << '\n';

    std::cout << "\nMagic numbers that are minimally pandigital in 0-9:\n";
    for (auto m : pandigital0)
        std::cout << m << '\n';
}
