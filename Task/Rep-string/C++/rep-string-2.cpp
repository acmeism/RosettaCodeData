#include <cstdint>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

std::string repeat(const std::string& text, const int32_t& repetitions) {
    std::stringstream stream;
    std::fill_n(std::ostream_iterator<std::string>(stream), repetitions, text);
    return stream.str();
}

std::vector<std::string> rep_string(const std::string& text) {
	std::vector<std::string> repetitions;

	for ( uint64_t len = 1; len <= text.length() / 2; ++len ) {
		std::string possible = text.substr(0, len);
		uint64_t quotient = text.length() / len;
		uint64_t remainder = text.length() % len;
		std::string candidate = repeat(possible, quotient) + possible.substr(0, remainder);
		if ( candidate == text ) {
			repetitions.emplace_back(possible);
		}
	}
	return repetitions;
}

int main() {
	const std::vector<std::string> tests = { "1001110011", "1110111011", "0010010010",
		"1010101010", "1111111111", "0100101101", "0100100", "101", "11", "00", "1" };

	std::cout << "The longest rep-strings are:" << std::endl;
	for ( const std::string& test : tests ) {
		std::vector<std::string> repeats = rep_string(test);
		std::string result = repeats.empty() ? "Not a rep-string" : repeats.back();
		std::cout << std::setw(10) << test << " -> " << result << std::endl;
	}
}
