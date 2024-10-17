#include <iostream>

int main() {
	const double negative_infinity = -1.0 / 0.0;
	const double infinity = 1.0 / 0.0;
	const double not_a_number = 0.0 / 0.0;
	const double negative_zero = -2.0 / infinity;

	std::cout << "Negative infinity   : " << negative_infinity << "\n";
	std::cout << "Positive infinity   : " << infinity << "\n";
	std::cout << "Infinity / 2        : " << infinity / 2 << "\n";
	std::cout << "NaN                 : " << not_a_number << "\n";
	std::cout << "Negative zero       : " << negative_zero << "\n";
	std::cout << "infinity + -infinity: " << ( infinity + negative_infinity ) << "\n";
	std::cout << "0 * NaN             : " << ( 0 * not_a_number ) << "\n";
	std::cout << "NaN == NaN          : " << std::boolalpha << ( not_a_number == not_a_number ) << "\n";
	std::cout << "0 == -0             : " << std::boolalpha << ( 0 == negative_zero ) << "\n";
}
