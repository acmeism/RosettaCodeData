#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>

constexpr int32_t ORDER_FIRST_MAGIC_SQUARE = 3;
constexpr double LN2 = log(2.0);
constexpr double LN10 = log(10.0);

// Return the magic constant for a magic square of the given order
int32_t magicConstant(int32_t n) {
	return n * ( n * n + 1 ) / 2;
}

// Return the smallest order of a magic square such that its magic constant is greater than 10 to the given power
int32_t minimumOrder(int32_t n) {
	return (int) exp( ( LN2 + n * LN10 ) / 3 ) + 1;
}

// Return the order of the magic square at the given index
int32_t order(int32_t index) {
	return ORDER_FIRST_MAGIC_SQUARE + index - 1;
}

int main() {
	std::cout << "The first 20 magic constants:" << std::endl;
	for ( int32_t i = 1; i <= 20; ++i ) {
		std::cout << " " << magicConstant(order(i));
	}
	std::cout << std::endl << std::endl;

	std::cout << "The 1,000th magic constant: " << magicConstant(order(1'000)) << std::endl << std::endl;

	std::cout << "Order of the smallest magic square whose constant is greater than:" << std::endl;
	for ( int32_t i = 1; i <= 20; ++i ) {
		std::string power_of_10 = "10^" + std::to_string(i) + ":";
		std::cout << std::setw(6) << power_of_10 << std::setw(8) << minimumOrder(i) << std::endl;
	}
}
