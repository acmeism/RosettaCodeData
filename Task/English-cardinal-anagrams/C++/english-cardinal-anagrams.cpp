#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <string>
#include <vector>

const std::vector<std::string> units = { "Zero", "One", "Two", "Three", "Four", "Five", "Six",
	"Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen",
	"Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };

const std::vector<std::string> tens =
	{ "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

std::string convert(const uint32_t& n) { // Valid for positive integers ≤ 999_999_999
	if ( n < 20 ) {
		return units[n];
	}
	if ( n < 100 ) {
		return tens[n / 10] + ( ( n % 10 > 0 ) ? " " + convert(n % 10) : "" );
	}
	if ( n < 1'000 ) {
		return units[n / 100] + " Hundred" + ( ( n % 100 > 0 ) ? " and " + convert(n % 100) : "" );
	}
	if ( n < 1'000'000 ) {
		return convert(n / 1'000) + " Thousand" + ( ( n % 1'000 > 0 ) ? " " + convert(n % 1'000) : "" );
	}
	return convert(n / 1'000'000) + " Million"
		+ ( ( n % 1'000'000 > 0 ) ? " " + convert(n % 1'000'000) : "" );
}

std::string to_lower_case(const std::string& text) {
	std::string result = text;
	std::transform(result.begin(), result.end(), result.begin(), [](char ch) { return std::tolower(ch); });
	return result;
}

void print_vector(std::vector<uint32_t> list) {
    std::cout << "[";
    for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
    }
    std::cout << list.back() << "]" << std::endl;
}

int main() {
	for ( uint32_t limit : { 1'000, 10'000 } ) {
	    std::map<std::vector<char>, std::vector<uint32_t>> anagrams = { };
	    for ( uint32_t i = 0; i < limit; ++i ) {
	    	std::string name = to_lower_case(convert(i));
	        std::vector<char> chars(name.begin(), name.end());
	        std::sort(chars.begin(), chars.end());
	        anagrams[chars].emplace_back(i);
	    }

	    if ( limit == 1'000 ) {
			std::vector<uint32_t> allAnagrams = { };
			for ( const auto& [key, value] : anagrams ) {
				if ( value.size() > 1 ) {
					allAnagrams.insert(allAnagrams.end(), value.begin(), value.end());
			    }
			}
			std::sort(allAnagrams.begin(), allAnagrams.end());
			std::cout << "First 30 English cardinal anagrams:" << std::endl;
			for ( uint32_t i = 0; i < 30; ++i ) {
				std::cout << std::setw(3) << allAnagrams[i] << ( ( i % 10 == 9 ) ? "\n" : " " );
			}
			std::cout << std::endl;
		}

	    const uint32_t count = std::count_if(anagrams.begin(), anagrams.end(),
	        [](const auto& pair) { return pair.second.size() > 1; });
		std::cout << "Count of English cardinal anagrams up to 1000: " << count << std::endl << std::endl;

		uint32_t max = 0;
		std::vector<std::vector<uint32_t>> largest = { };
		for ( const auto& [key, value] : anagrams ) {
			if ( value.size() > max ) {
				max = value.size();
				largest = { value };
			} else if ( value.size() == max ) {
				largest.emplace_back(value);
			}
		}
		std::cout << "Largest group(s) of English cardinal anagrams up to " << limit << ": " << std::endl;
		std::sort(largest.begin(), largest.end(),
			[](const std::vector<uint32_t>& a, const std::vector<uint32_t>& b) { return a[0] < b[0]; });
		std::for_each(largest.begin(), largest.end(), print_vector);
		std::cout << std::endl;
	}

}
