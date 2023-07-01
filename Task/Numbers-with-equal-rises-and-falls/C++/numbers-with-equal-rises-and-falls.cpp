#include <iomanip>
#include <iostream>

bool equal_rises_and_falls(int n) {
    int total = 0;
    for (int previous_digit = -1; n > 0; n /= 10) {
        int digit = n % 10;
        if (previous_digit > digit)
            ++total;
        else if (previous_digit >= 0 && previous_digit < digit)
            --total;
        previous_digit = digit;
    }
    return total == 0;
}

int main() {
    const int limit1 = 200;
    const int limit2 = 10000000;
    int n = 0;
    std::cout << "The first " << limit1 << " numbers in the sequence are:\n";
    for (int count = 0; count < limit2; ) {
        if (equal_rises_and_falls(++n)) {
            ++count;
            if (count <= limit1)
                std::cout << std::setw(3) << n << (count % 20 == 0 ? '\n' : ' ');
        }
    }
    std::cout << "\nThe " << limit2 << "th number in the sequence is " << n << ".\n";
}
