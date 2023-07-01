#include <iostream>
#include <string>
#include <cctype>
#include <cstdint>

typedef std::uint64_t integer;

const char* small[] = {
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
    "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
    "sixteen", "seventeen", "eighteen", "nineteen"
};

const char* tens[] = {
    "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
};

struct named_number {
    const char* name_;
    integer number_;
};

const named_number named_numbers[] = {
    { "hundred", 100 },
    { "thousand", 1000 },
    { "million", 1000000 },
    { "billion", 1000000000 },
    { "trillion", 1000000000000 },
    { "quadrillion", 1000000000000000ULL },
    { "quintillion", 1000000000000000000ULL }
};

const named_number& get_named_number(integer n) {
    constexpr size_t names_len = std::size(named_numbers);
    for (size_t i = 0; i + 1 < names_len; ++i) {
        if (n < named_numbers[i + 1].number_)
            return named_numbers[i];
    }
    return named_numbers[names_len - 1];
}

std::string cardinal(integer n) {
    std::string result;
    if (n < 20)
        result = small[n];
    else if (n < 100) {
        result = tens[n/10 - 2];
        if (n % 10 != 0) {
            result += "-";
            result += small[n % 10];
        }
    } else {
        const named_number& num = get_named_number(n);
        integer p = num.number_;
        result = cardinal(n/p);
        result += " ";
        result += num.name_;
        if (n % p != 0) {
            result += " ";
            result += cardinal(n % p);
        }
    }
    return result;
}

inline char uppercase(char ch) {
    return static_cast<char>(std::toupper(static_cast<unsigned char>(ch)));
}

std::string magic(integer n) {
    std::string result;
    for (unsigned int i = 0; ; ++i) {
        std::string text(cardinal(n));
        if (i == 0)
            text[0] = uppercase(text[0]);
        result += text;
        if (n == 4) {
            result += " is magic.";
            break;
        }
        integer len = text.length();
        result += " is ";
        result += cardinal(len);
        result += ", ";
        n = len;
    }
    return result;
}

void test_magic(integer n) {
    std::cout << magic(n) << '\n';
}

int main() {
    test_magic(5);
    test_magic(13);
    test_magic(78);
    test_magic(797);
    test_magic(2739);
    test_magic(4000);
    test_magic(7893);
    test_magic(93497412);
    test_magic(2673497412U);
    test_magic(10344658531277200972ULL);
    return 0;
}
