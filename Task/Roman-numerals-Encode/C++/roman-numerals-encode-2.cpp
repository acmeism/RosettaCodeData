#include <iostream>
#include <string>

std::string to_roman(int x) {
    auto roman_digit = [&](char one, char five, char ten, int x) {
        if (x <= 3)
            return std::string().assign(x, one);
        if (x <= 5)
            return std::string().assign(5 - x, one) + five;
        if (x <= 8)
           return five + std::string().assign(x - 5, one);
        return std::string().assign(10 - x, one) + ten;
    };
    if (x <= 0)
        return "Negative or zero!";
    if (x >= 1000)
        return "M" + to_roman(x - 1000);
    if (x >= 100)
        return roman_digit('C', 'D', 'M', x / 100) + to_roman(x % 100);
    if (x >= 10)
        return roman_digit('X', 'L', 'C', x / 10) + to_roman(x % 10);
    return roman_digit('I', 'V', 'X', x);
}

int main(){
    for (int i = 1; i < 2018; i+= 1)
        std::cout << i << " --> " << to_roman(i) << std::endl;
}
