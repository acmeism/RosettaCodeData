#include <algorithm>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <string>

unsigned int reverse(unsigned int base, unsigned int n) {
    unsigned int rev = 0;
    for (; n > 0; n /= base)
        rev = rev * base + (n % base);
    return rev;
}

class palindrome_generator {
public:
    explicit palindrome_generator(unsigned int base)
        : base_(base), upper_(base) {}
    unsigned int next_palindrome();

private:
    unsigned int base_;
    unsigned int lower_ = 1;
    unsigned int upper_;
    unsigned int next_ = 0;
    bool even_ = false;
};

unsigned int palindrome_generator::next_palindrome() {
    ++next_;
    if (next_ == upper_) {
        if (even_) {
            lower_ = upper_;
            upper_ *= base_;
        }
        next_ = lower_;
        even_ = !even_;
    }
    return even_ ? next_ * upper_ + reverse(base_, next_)
                 : next_ * lower_ + reverse(base_, next_ / base_);
}

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (unsigned int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

std::string to_string(unsigned int base, unsigned int n) {
    assert(base <= 36);
    static constexpr char digits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    std::string str;
    for (; n != 0; n /= base)
        str += digits[n % base];
    std::reverse(str.begin(), str.end());
    return str;
}

void print_palindromic_primes(unsigned int base, unsigned int limit) {
    auto width =
        static_cast<unsigned int>(std::ceil(std::log(limit) / std::log(base)));
    unsigned int count = 0;
    auto columns = 80 / (width + 1);
    std::cout << "Base " << base << " palindromic primes less than " << limit
              << ":\n";
    palindrome_generator pgen(base);
    unsigned int palindrome;
    while ((palindrome = pgen.next_palindrome()) < limit) {
        if (is_prime(palindrome)) {
            ++count;
            std::cout << std::setw(width) << to_string(base, palindrome)
                      << (count % columns == 0 ? '\n' : ' ');
        }
    }
    if (count % columns != 0)
        std::cout << '\n';
    std::cout << "Count: " << count << '\n';
}

void count_palindromic_primes(unsigned int base, unsigned int limit) {
    unsigned int count = 0;
    palindrome_generator pgen(base);
    unsigned int palindrome;
    while ((palindrome = pgen.next_palindrome()) < limit)
        if (is_prime(palindrome))
            ++count;
    std::cout << "Number of base " << base << " palindromic primes less than "
              << limit << ": " << count << '\n';
}

int main() {
    print_palindromic_primes(10, 1000);
    std::cout << '\n';
    print_palindromic_primes(10, 100000);
    std::cout << '\n';
    count_palindromic_primes(10, 1000000000);
    std::cout << '\n';
    print_palindromic_primes(16, 500);
}
