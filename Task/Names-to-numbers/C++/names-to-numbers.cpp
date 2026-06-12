#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <regex>
#include <stdexcept>
#include <string>
#include <vector>

const std::string WHITESPACE = " \n\r\t\f\v";

const std::vector<std::string> ZEROS = { "zero", "nought", "nil", "none", "nothing" };

std::map<std::string, uint64_t> NAMES = {
	{ "one", 1 }, { "two", 2 }, { "three", 3 }, { "four", 4 }, { "five", 5 }, { "six", 6 },
	{ "seven", 7 }, { "eight", 8 }, { "nine", 9 }, { "ten", 10 }, { "eleven", 11 },
	{ "twelve", 12 }, { "thirteen", 13 }, { "fourteen", 14 }, { "fifteen", 15 },
	{ "sixteen", 16 }, { "seventeen", 17 }, { "eighteen", 18 }, { "nineteen", 19 },
	{ "twenty", 20 }, { "thirty", 30 }, { "forty", 40 }, { "fifty", 50 }, { "sixty", 60 },
	{ "seventy", 70 }, { "eighty", 80 }, { "ninety", 90 }, { "hundred", 100 },
	{ "thousand", 1'000 }, { "million", 1'000'000 }, { "billion", 1'000'000'000 },
	{ "trillion", 1'000'000'000'000 }, { "quadrillion", 1'000'000'000'000'000 },
	{ "quintillion", 1'000'000'000'000'000'000 } };

std::string trim(const std::string& text) {
    const uint64_t start = text.find_first_not_of(WHITESPACE);
    std::string temp = ( start == std::string::npos ) ? "" : text.substr(start);

    const uint64_t end = temp.find_last_not_of(WHITESPACE);
    return ( end == std::string::npos ) ? "" : temp.substr(0, end + 1);
}

std::string to_lower_case(const std::string& text) {
	std::string result = text;
	std::transform(result.begin(), result.end(), result.begin(),
		[](char ch){ return std::tolower(ch); });
	return result;
}

std::vector<std::string> split(const std::string& text, const std::string& splitter) {
  static std::regex re(splitter);
  std::sregex_token_iterator iter(text.begin(), text.end(), re, -1);
  std::sregex_token_iterator end;

  std::vector<std::string> elements{ };
  while ( iter != end ) {
      if ( iter->length() ) {
    	  elements.emplace_back(*iter);
      }
      iter++;
  }
  return elements;
}

int64_t name_to_number(const std::string& name) {
	std::string text = to_lower_case(trim(name));
	const bool is_negative = ( text.substr(0, 6) == "minus " );
	if ( is_negative ) {
		text = text.substr(6);
	}
	if ( text.substr(0, 2) == "a " ) {
		text = "one" + text.substr(1);
	}
	std::vector<std::string> words = split(text, " and |-| |,");
	if ( words.size() == 1 && std::find(ZEROS.begin(), ZEROS.end(), words[0]) != ZEROS.end() ) {
		return 0;
	}

	uint64_t multiplier = 1;
	uint64_t lastNumber = 0;
	uint64_t sum = 0;
	for ( int32_t i = words.size() - 1; i >= 0; --i ) {
		if ( ! NAMES.contains(words[i]) ) {
			throw std::invalid_argument("'" + words[i] + "' is not a valid number");
		}

		uint64_t number = NAMES[words[i]];
		if ( number == lastNumber ) {
			throw std::invalid_argument("'" + name + "' is not a well formed numeric string");
		} else if ( number >= 1'000 ) {
			if ( lastNumber >= 100 ) {
				throw std::invalid_argument("'" + name + "' is not a well formed numeric string");
			}
			multiplier = number;
			if ( i == 0 ) {
				sum += multiplier;
			}
		} else if ( number >= 100 ) {
			multiplier *= 100;
			if ( i == 0 ) {
				sum += multiplier;
			}
		} else if ( number >= 20 ) {
			if ( lastNumber >= 10 && lastNumber <= 90 ) {
				throw std::invalid_argument("'" + name + "' is not a well formed numeric string");
			}
			sum += number * multiplier;
		} else {
			if ( lastNumber >= 1 && lastNumber <= 90 ) {
				throw std::invalid_argument("'" + name + "' is not a well formed numeric string");
			}
			sum += number * multiplier;
		}

		lastNumber = number;
	}

    if ( is_negative && sum == -sum ) {
		return INT64_MIN;
	}
	if ( sum < 0 ) {
		throw std::invalid_argument("'" + name + "' is outside the range of a long integer");
	}
	return is_negative ? -sum : sum;
}

int main() {
	const std::vector<std::string> tests = {
		"none",
		"one",
		"twenty-five",
		"minus one hundred and seventeen",
		"hundred and fifty-six",
		"minus two thousand two",
		"nine thousand, seven hundred, one",
		"minus six hundred and twenty six thousand, eight hundred and fourteen",
		"four million, seven hundred thousand, three hundred and eighty-six",
		"fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four",
		"two hundred and one billion, twenty-one million, two thousand and one",
		"minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
		"seventeen quadrillion, one hundred thirty-seven",
		"a quintillion, eight trillion and five",
		"minus nine quintillion, two hundred and twenty-three quadrillion, three hundred and seventy-two trillion, thirty-six billion, eight hundred and fifty-four million, seven hundred and seventy-five thousand, eight hundred and eight"
	};

	std::for_each(tests.begin(), tests.end(), [](const std::string& test) {
		std::cout << std::setw(20) << name_to_number(test) << " = " << test << std::endl;} );
}
