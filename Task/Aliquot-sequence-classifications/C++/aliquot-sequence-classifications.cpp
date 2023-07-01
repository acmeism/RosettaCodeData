#include <cstdint>
#include <iostream>
#include <string>

using integer = uint64_t;

// See https://en.wikipedia.org/wiki/Divisor_function
integer divisor_sum(integer n) {
    integer total = 1, power = 2;
    // Deal with powers of 2 first
    for (; n % 2 == 0; power *= 2, n /= 2)
        total += power;
    // Odd prime factors up to the square root
    for (integer p = 3; p * p <= n; p += 2) {
        integer sum = 1;
        for (power = p; n % p == 0; power *= p, n /= p)
            sum += power;
        total *= sum;
    }
    // If n > 1 then it's prime
    if (n > 1)
        total *= n + 1;
    return total;
}

// See https://en.wikipedia.org/wiki/Aliquot_sequence
void classify_aliquot_sequence(integer n) {
    constexpr int limit = 16;
    integer terms[limit];
    terms[0] = n;
    std::string classification("non-terminating");
    int length = 1;
    for (int i = 1; i < limit; ++i) {
        ++length;
        terms[i] = divisor_sum(terms[i - 1]) - terms[i - 1];
        if (terms[i] == n) {
            classification =
                (i == 1 ? "perfect" : (i == 2 ? "amicable" : "sociable"));
            break;
        }
        int j = 1;
        for (; j < i; ++j) {
            if (terms[i] == terms[i - j])
                break;
        }
        if (j < i) {
            classification = (j == 1 ? "aspiring" : "cyclic");
            break;
        }
        if (terms[i] == 0) {
            classification = "terminating";
            break;
        }
    }
    std::cout << n << ": " << classification << ", sequence: " << terms[0];
    for (int i = 1; i < length && terms[i] != terms[i - 1]; ++i)
        std::cout << ' ' << terms[i];
    std::cout << '\n';
}

int main() {
    for (integer i = 1; i <= 10; ++i)
        classify_aliquot_sequence(i);
    for (integer i : {11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562,
                      1064, 1488})
        classify_aliquot_sequence(i);
    classify_aliquot_sequence(15355717786080);
    classify_aliquot_sequence(153557177860800);
    return 0;
}
