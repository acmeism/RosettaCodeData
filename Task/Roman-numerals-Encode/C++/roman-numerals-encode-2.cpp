#include <iostream>
#include <string>

std::string to_roman(int x) {
     if (x <= 0)
         return "Negative or zero!";
     auto roman_digit = [](char one, char five, char ten, int x) {
        if (x <= 3)
            return std::string().assign(x, one);
        if (x <= 5)
            return std::string().assign(5 - x, one) + five;
        if (x <= 8)
            return five + std::string().assign(x - 5, one);
        return std::string().assign(10 - x, one) + ten;
    };
    if (x >= 1000)
        return x - 1000 > 0 ? "M" + to_roman(x - 1000) : "M";
    if (x >= 100) {
        auto s = roman_digit('C', 'D', 'M', x / 100);
        return x % 100 > 0 ? s + to_roman(x % 100) : s;
    }
    if (x >= 10) {
        auto s = roman_digit('X', 'L', 'C', x / 10);
        return x % 10 > 0 ? s + to_roman(x % 10) : s;
    }
    return roman_digit('I', 'V', 'X', x);
}

int main() {
    for (int i = 0; i < 2018; i++)
        std::cout << i << " --> " << to_roman(i) << std::endl;
}
