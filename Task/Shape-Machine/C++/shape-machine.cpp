#include <cstdint>
#include <iomanip>
#include <iostream>

int main() {
    double user_choice;
    std::cout << "Enter a number: ";
    std::cin >> user_choice;

    const double epsilon = 0.000'000'000'000'1;
    uint32_t iterations = 0;
    double previous = 0.0;
    double current = user_choice;

    while ( std::abs(current - previous) > epsilon ) {
        previous = current;
        current = ( current + 3.0 ) * 0.86;
        iterations++;
    }

    std::cout << user_choice << " converged to " << std::fixed << std::setprecision(12)
              << current << " after " << iterations << " iterations." << std::endl;
}
