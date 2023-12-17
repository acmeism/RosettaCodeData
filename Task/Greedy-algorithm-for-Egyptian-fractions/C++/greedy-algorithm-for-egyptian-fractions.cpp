#include <boost/multiprecision/cpp_int.hpp>
#include <iostream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

typedef boost::multiprecision::cpp_int integer;

struct fraction {
    fraction(const integer& n, const integer& d)
        : numerator(n), denominator(d) {}
    integer numerator;
    integer denominator;
};

integer mod(const integer& x, const integer& y) { return ((x % y) + y) % y; }

size_t count_digits(const integer& i) {
    std::ostringstream os;
    os << i;
    return os.str().length();
}

std::string to_string(const integer& i) {
    const int max_digits = 20;
    std::ostringstream os;
    os << i;
    std::string s = os.str();
    if (s.length() > max_digits)
        s.replace(max_digits / 2, s.length() - max_digits, "...");
    return s;
}

std::ostream& operator<<(std::ostream& out, const fraction& f) {
    return out << to_string(f.numerator) << '/' << to_string(f.denominator);
}

void egyptian(const fraction& f, std::vector<fraction>& result) {
    result.clear();
    integer x = f.numerator, y = f.denominator;
    while (x > 0) {
        integer z = (y + x - 1) / x;
        result.emplace_back(1, z);
        x = mod(-y, x);
        y = y * z;
    }
}

void print_egyptian(const std::vector<fraction>& result) {
    if (result.empty())
        return;
    auto i = result.begin();
    std::cout << *i++;
    for (; i != result.end(); ++i)
        std::cout << " + " << *i;
    std::cout << '\n';
}

void print_egyptian(const fraction& f) {
    std::cout << "Egyptian fraction for " << f << ": ";
    integer x = f.numerator, y = f.denominator;
    if (x > y) {
        std::cout << "[" << x / y << "] ";
        x = x % y;
    }
    std::vector<fraction> result;
    egyptian(fraction(x, y), result);
    print_egyptian(result);
    std::cout << '\n';
}

void show_max_terms_and_max_denominator(const integer& limit) {
    size_t max_terms = 0;
    std::optional<fraction> max_terms_fraction, max_denominator_fraction;
    std::vector<fraction> max_terms_result;
    integer max_denominator = 0;
    std::vector<fraction> max_denominator_result;
    std::vector<fraction> result;
    for (integer b = 2; b < limit; ++b) {
        for (integer a = 1; a < b; ++a) {
            fraction f(a, b);
            egyptian(f, result);
            if (result.size() > max_terms) {
                max_terms = result.size();
                max_terms_result = result;
                max_terms_fraction = f;
            }
            const integer& denominator = result.back().denominator;
            if (denominator > max_denominator) {
                max_denominator = denominator;
                max_denominator_result = result;
                max_denominator_fraction = f;
            }
        }
    }
    std::cout
        << "Proper fractions with most terms and largest denominator, limit = "
        << limit << ":\n\n";
    std::cout << "Most terms (" << max_terms
              << "): " << max_terms_fraction.value() << " = ";
    print_egyptian(max_terms_result);
    std::cout << "\nLargest denominator ("
              << count_digits(max_denominator_result.back().denominator)
              << " digits): " << max_denominator_fraction.value() << " = ";
    print_egyptian(max_denominator_result);
}

int main() {
    print_egyptian(fraction(43, 48));
    print_egyptian(fraction(5, 121));
    print_egyptian(fraction(2014, 59));
    show_max_terms_and_max_denominator(100);
    show_max_terms_and_max_denominator(1000);
    return 0;
}
