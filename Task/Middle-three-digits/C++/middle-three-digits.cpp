#include <iostream>

std::string middleThreeDigits(int n)
{
    auto number = std::to_string(std::abs(n));
    auto length = number.size();

    if (length < 3) {
        return "less than three digits";
    } else if (length % 2 == 0) {
        return "even number of digits";
    } else {
        return number.substr(length / 2 - 1, 3);
    }
}

int main()
{
    auto values {123, 12345, 1234567, 987654321, 10001,
                 -10001, -123, -100, 100, -12345,
                 1, 2, -1, -10, 2002, -2002, 0};

    for (auto&& v : values) {
        std::cout << "middleThreeDigits(" << v << "): " <<
                     middleThreeDigits(v) << "\n";
    }
}
