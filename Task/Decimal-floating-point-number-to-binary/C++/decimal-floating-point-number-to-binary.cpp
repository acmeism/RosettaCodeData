#include <algorithm>
#include <bitset>
#include <cstdint>
#include <cmath>
#include <iostream>
#include <string>

std::string decimal_to_binary(double number) {
	std::string minus = "";
	if ( number < 0.0 ) {
		minus = "-";
		number = -number;
	}

    const uint64_t integer_part = std::floor(number);
    std::string binary = std::bitset<64>(number).to_string();
    const int32_t index = binary.find("1");
    binary = binary.substr(index);

    double fractional_part = number - integer_part;
    while ( fractional_part > 0.0 ) {
        const double residue = fractional_part * 2.0;
        if ( residue >= 1.0 ) {
            binary += "1";
            fractional_part = residue - 1;
        } else {
            binary += "0";
            fractional_part = residue;
        }
    }

    return minus + binary;
}

double binary_to_decimal(std::string binary) {
	if ( binary == "" ) {
		return 0.0;
	}

	double multiplier = +1.0;
	if ( binary.starts_with("-") ) {
		multiplier = -1.0;
		binary = binary.substr(1);
	}

	std::string copy_binary = binary;
	std::erase(copy_binary, '.');
	const uint64_t numerator = std::stoll(copy_binary, nullptr, 2);

	const int32_t index = binary.find(".");
	if ( index < 0 ) {
		return numerator * multiplier;
	}

	std::string temp = binary.substr(index + 1);
	std::replace(temp.begin(), temp.end(), '1', '0');
	const uint64_t denominator = std::stoll("1" + temp, nullptr, 2);

    return numerator * multiplier / denominator;
}

int main() {
	std::cout << "23.34375     => " << decimal_to_binary(23.34375) << std::endl;
	std::cout << "1011.11101   => " << binary_to_decimal("1011.11101") << std::endl;
	std::cout << "-23.34375    => " << decimal_to_binary(-23.34375) << std::endl;
	std::cout << "-1011.11101  => " << binary_to_decimal("-1011.11101") << std::endl;
	std::cout << "64           => " << decimal_to_binary(64) << std::endl;
	std::cout << "-100001      => " << binary_to_decimal("-100001") << std::endl;
}
