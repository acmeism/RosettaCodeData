#include <algorithm>
#include <cassert>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <string>

std::string cardinal(int n) {
    static const char* small[] = {
        "zero",    "one",     "two",       "three",    "four",
        "five",    "six",     "seven",     "eight",    "nine",
        "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen",
    };
    static const char* tens[] = {
        "twenty", "thirty",  "forty",  "fifty",
        "sixty",  "seventy", "eighty", "ninety",
    };
    assert(n >= 0 && n < 1000);
    std::string str;
    if (n < 20)
        str = small[n];
    else if (n < 100) {
        str = tens[n / 10 - 2];
        if (n % 10 != 0) {
            str += "-";
            str += small[n % 10];
        }
    } else {
        str = cardinal(n / 100);
        str += " hundred";
        if (n % 100 != 0) {
            str += " ";
            str += cardinal(n % 100);
        }
    }
    return str;
}

class a363659_generator {
public:
    explicit a363659_generator() : num(0) {
        for (int i = 0; i < 1000; ++i) {
            std::string name = cardinal(i);
            first[i] = name.front();
            last[i] = name.back();
        }
    }
    int next() {
        while (first_char(num + 1) != last_char(num))
            ++num;
        return num++;
    }

private:
    char first_char(int n) const {
        int i = 0;
        for (; n > 0; n /= 1000)
            i = n % 1000;
        return first[i];
    }
    char last_char(int n) const {
        int i = n % 1000;
        if (i > 0)
            return last[i];
        else if (n == 0)
            return last[0];
        else if (n % 1000000 == 0)
            return 'n';
        return 'd';
    }
    int num;
    char first[1000];
    char last[1000];
};

template <typename Iterator>
void histogram(Iterator begin, Iterator end) {
    if (begin == end)
        return;
    double max_value = *std::max_element(begin, end);
    const int width = 60;
    int i = 0;
    for (Iterator it = begin; it != end; ++it) {
        std::cout << i++ << ": ";
        double value = *it;
        int n = max_value != 0 ? std::lround((value * width) / max_value) : 0;
        int j = 0;
        for (; j < n; ++j)
            std::cout << u8"\u2586";
        for (; j < width; ++j)
            std::cout << ' ';
        std::cout << ' ' << *it << '\n';
    }
}

int main() {
    std::cout << "First 50 numbers:\n";
    a363659_generator gen;
    int count[10] = {};
    int i = 1, n;
    for (; i <= 50; ++i) {
        n = gen.next();
        ++count[n % 10];
        std::cout << std::setw(3) << n << (i % 10 == 0 ? '\n' : ' ');
    }
    for (int limit = 1000; limit <= 1000000; limit *= 10) {
        for (; i <= limit; ++i) {
            n = gen.next();
            ++count[n % 10];
        }
        std::cout << "\nThe " << limit << "th number is " << n << ".\n";
        std::cout << "Breakdown by last digit of first " << limit
                  << " numbers:\n";
        histogram(count, count + 10);
    }
}
