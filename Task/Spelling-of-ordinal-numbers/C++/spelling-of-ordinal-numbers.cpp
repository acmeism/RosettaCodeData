#include <iostream>
#include <string>
#include <cstdint>

typedef std::uint64_t integer;

struct number_names {
    const char* cardinal;
    const char* ordinal;
};

const number_names small[] = {
    { "zero", "zeroth" }, { "one", "first" }, { "two", "second" },
    { "three", "third" }, { "four", "fourth" }, { "five", "fifth" },
    { "six", "sixth" }, { "seven", "seventh" }, { "eight", "eighth" },
    { "nine", "ninth" }, { "ten", "tenth" }, { "eleven", "eleventh" },
    { "twelve", "twelfth" }, { "thirteen", "thirteenth" },
    { "fourteen", "fourteenth" }, { "fifteen", "fifteenth" },
    { "sixteen", "sixteenth" }, { "seventeen", "seventeenth" },
    { "eighteen", "eighteenth" }, { "nineteen", "nineteenth" }
};

const number_names tens[] = {
    { "twenty", "twentieth" }, { "thirty", "thirtieth" },
    { "forty", "fortieth" }, { "fifty", "fiftieth" },
    { "sixty", "sixtieth" }, { "seventy", "seventieth" },
    { "eighty", "eightieth" }, { "ninety", "ninetieth" }
};

struct named_number {
    const char* cardinal;
    const char* ordinal;
    integer number;
};

const named_number named_numbers[] = {
    { "hundred", "hundredth", 100 },
    { "thousand", "thousandth", 1000 },
    { "million", "millionth", 1000000 },
    { "billion", "billionth", 1000000000 },
    { "trillion", "trillionth", 1000000000000 },
    { "quadrillion", "quadrillionth", 1000000000000000ULL },
    { "quintillion", "quintillionth", 1000000000000000000ULL }
};

const char* get_name(const number_names& n, bool ordinal) {
    return ordinal ? n.ordinal : n.cardinal;
}

const char* get_name(const named_number& n, bool ordinal) {
    return ordinal ? n.ordinal : n.cardinal;
}

const named_number& get_named_number(integer n) {
    constexpr size_t names_len = std::size(named_numbers);
    for (size_t i = 0; i + 1 < names_len; ++i) {
        if (n < named_numbers[i + 1].number)
            return named_numbers[i];
    }
    return named_numbers[names_len - 1];
}

std::string number_name(integer n, bool ordinal) {
    std::string result;
    if (n < 20)
        result = get_name(small[n], ordinal);
    else if (n < 100) {
        if (n % 10 == 0) {
            result = get_name(tens[n/10 - 2], ordinal);
        } else {
            result = get_name(tens[n/10 - 2], false);
            result += "-";
            result += get_name(small[n % 10], ordinal);
        }
    } else {
        const named_number& num = get_named_number(n);
        integer p = num.number;
        result = number_name(n/p, false);
        result += " ";
        if (n % p == 0) {
            result += get_name(num, ordinal);
        } else {
            result += get_name(num, false);
            result += " ";
            result += number_name(n % p, ordinal);
        }
    }
    return result;
}

void test_ordinal(integer n) {
    std::cout << n << ": " << number_name(n, true) << '\n';
}

int main() {
    test_ordinal(1);
    test_ordinal(2);
    test_ordinal(3);
    test_ordinal(4);
    test_ordinal(5);
    test_ordinal(11);
    test_ordinal(15);
    test_ordinal(21);
    test_ordinal(42);
    test_ordinal(65);
    test_ordinal(98);
    test_ordinal(100);
    test_ordinal(101);
    test_ordinal(272);
    test_ordinal(300);
    test_ordinal(750);
    test_ordinal(23456);
    test_ordinal(7891233);
    test_ordinal(8007006005004003LL);
    return 0;
}
