#include <algorithm>
#include <bitset>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>

enum Type { STANDARD, EXTENDED };

std::string encode(const int32_t& n, const uint32_t& k, const Type& type) {
	int32_t value = n;
	if ( type == Type::EXTENDED ) {
		value = ( value < 0 ) ? -value * 2 - 1 : 2 * value;
	}

	if ( value < 0 ) {
		throw std::invalid_argument("n cannot be negative: " + n);
	}

	const uint32_t m = 1 << k;
	const uint32_t quotient = value / m;
	const uint32_t remainder = value % m;
	std::string ones = std::string(quotient, '1');
	std::string binary = std::bitset<32>(remainder).to_string();
	std::string binary_remainder = binary.substr(binary.length() - k - 1);

	return ones + binary_remainder;
}

int32_t decode(const std::string& encoded, const uint32_t& k, const Type& type) {
	const uint32_t m = 1 << k;
	const uint32_t index = encoded.find("0");
	const uint32_t quotient = std::max(static_cast<uint32_t>(0), index);
	const uint32_t remainder = std::stoi(encoded.substr(quotient), nullptr, 2);
	int32_t result = quotient * m + remainder;

	if ( type == Type::EXTENDED ) {
		result = ( result % 2 == 1 ) ? -( ( result + 1 ) / 2 ) : result / 2;
	}
	return result;
}

int main() {
	std::cout << "Base Rice Coding with k = 2:" << std::endl;
	for ( uint32_t n = 0; n <= 10; ++n ) {
		std::string encoded = encode(n, 2, Type::STANDARD);
		std::cout << n << " -> " << encoded << " -> " << decode(encoded, 2, Type::STANDARD) << std::endl;
	}
	std::cout << std::endl;

	std::cout << "Extended Rice Coding with k = 2:" << std::endl;
	for ( int32_t n = -10; n <= 10; ++n ) {
		std::string encoded = encode(n, 2, Type::EXTENDED);
		std::cout << n << " -> " << encoded << " -> " << decode(encoded, 2, Type::EXTENDED) << std::endl;
	}
	std::cout << std::endl;

	std::cout << "Base Rice Coding with k = 4:" << std::endl;
	for ( uint32_t n = 0; n <= 17; ++n ) {
		std::string encoded = encode(n, 4, Type::STANDARD);
		std::cout << n << " -> " << encoded << " -> " << decode(encoded, 4, Type::STANDARD) << std::endl;
	}
}
