#include <iostream>
#include <cstdint>

typedef uint64_t integer;

integer reverse(integer n) {
    integer rev = 0;
    while (n > 0) {
        rev = rev * 10 + (n % 10);
        n /= 10;
    }
    return rev;
}

// generates base 10 palindromes greater than 100 starting
// with the specified digit
class palindrome_generator {
public:
    palindrome_generator(int digit) : power_(10), next_(digit * power_ - 1),
        digit_(digit), even_(false) {}
    integer next_palindrome() {
        ++next_;
        if (next_ == power_ * (digit_ + 1)) {
            if (even_)
                power_ *= 10;
            next_ = digit_ * power_;
            even_ = !even_;
        }
        return next_ * (even_ ? 10 * power_ : power_)
            + reverse(even_ ? next_ : next_/10);
    }
private:
    integer power_;
    integer next_;
    int digit_;
    bool even_;
};

bool gapful(integer n) {
    integer m = n;
    while (m >= 10)
        m /= 10;
    return n % (n % 10 + 10 * m) == 0;
}

template<size_t len>
void print(integer (&array)[9][len]) {
    for (int digit = 1; digit < 10; ++digit) {
        std::cout << digit << ":";
        for (int i = 0; i < len; ++i)
            std::cout << ' ' << array[digit - 1][i];
        std::cout << '\n';
    }
}

int main() {
    const int n1 = 20, n2 = 15, n3 = 10;
    const int m1 = 100, m2 = 1000;

    integer pg1[9][n1];
    integer pg2[9][n2];
    integer pg3[9][n3];

    for (int digit = 1; digit < 10; ++digit) {
        palindrome_generator pgen(digit);
        for (int i = 0; i < m2; ) {
            integer n = pgen.next_palindrome();
            if (!gapful(n))
                continue;
            if (i < n1)
                pg1[digit - 1][i] = n;
            else if (i < m1 && i >= m1 - n2)
                pg2[digit - 1][i - (m1 - n2)] = n;
            else if (i >= m2 - n3)
                pg3[digit - 1][i - (m2 - n3)] = n;
            ++i;
        }
    }

    std::cout << "First " << n1 << " palindromic gapful numbers ending in:\n";
    print(pg1);

    std::cout << "\nLast " << n2 << " of first " << m1 << " palindromic gapful numbers ending in:\n";
    print(pg2);

    std::cout << "\nLast " << n3 << " of first " << m2 << " palindromic gapful numbers ending in:\n";
    print(pg3);

    return 0;
}
