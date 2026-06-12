#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <set>
#include <string>
#include <vector>

bool has_significant_strings(const std::set<std::string>& strings) {
	for ( const std::string& string : strings ) {
		if ( string.length() > 1 ) {
			return true;
		}
	}
	return false;
}

std::set<std::string> all_palindromes(const std::string& number) {
	std::vector<std::string> substrings{ };
	for ( uint32_t i = 0; i < number.length(); ++i ) {
		for ( uint32_t j = 1; j <= number.length() - i; ++j ) {
			substrings.emplace_back(number.substr(i, j));
		}
	}

	std::set<std::string> palindromes{ };
	for ( std::string substring : substrings ) {
		const std::string substring_copy = substring;
		std::reverse(substring.begin(), substring.end());
		if ( substring == substring_copy ) {
			palindromes.insert(substring);
		}
	}
	return palindromes;
}

int main() {
	std::cout << "Number  Palindromes" << std::endl;
	for ( uint32_t i = 100; i <= 125; ++i ) {
		std::set<std::string> palindromes = all_palindromes(std::to_string(i));
		std::cout << i << "  ";
		for ( const std::string& palindrome : palindromes ) {
			std::cout << std::setw(5) << palindrome;
		}
		std::cout << std::endl;
	}

	const std::vector<std::string> numbers = { "9", "169", "12769", "1238769", "123498769", "12346098769",
	    "1234572098769", "123456832098769", "12345679432098769", "1234567905432098769",
	    "123456790165432098769", "83071934127905179083", "1320267947849490361205695" };

	std::cout << "\nNumber            Has no >= 2 digit palindromes" << std::endl;
	for ( const std::string& number : numbers ) {
		const bool none = ! has_significant_strings(all_palindromes(number));
		std::cout << std::left << std::setw(26) << number
                  << std::setw(1) << std::boolalpha << none << std::endl;
	}
}
