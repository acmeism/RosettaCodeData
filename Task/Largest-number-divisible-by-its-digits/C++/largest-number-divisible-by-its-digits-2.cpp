#include <algorithm>
#include <cstdint>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_set>

std::string to_hex_string(const uint64_t& hexadecimal) {
	std::stringstream stream;
	stream << std::hex << hexadecimal;
	return stream.str();
}

bool is_lynch_bell(const uint64_t& hexadecimal) {
	std::string hex_string = to_hex_string(hexadecimal);
	if ( hex_string.find('0') != std::string::npos ) {
		return false;
	}

	std::unordered_set<uint32_t> distinct_digits = { };
	for ( const char ch : hex_string ) {
		distinct_digits.insert(( ch >= 'a') ? ( ch - 'a' + 10 ) : ( ch - '0' ));
	}
	if ( distinct_digits.size() < hex_string.size() ) {
		return false;
	}

	for ( const uint32_t& digit : distinct_digits ) {
		if ( hexadecimal % digit > 0 ) {
			return false;
		}
	}
	return true;
}

int main() {
	const uint64_t hex_divisor = 15 * 14 * 13 * 12 * 11;

	uint64_t hexadecimal = ( 0xfedcba987654321L / hex_divisor ) * hex_divisor;
	while ( ! is_lynch_bell(hexadecimal) ) {
		hexadecimal -= hex_divisor;
	}
	std::cout << "The largest hexadecimal Lynch-Bell number is " << to_hex_string(hexadecimal) << std::endl;
}
