#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

std::pair<std::vector<uint32_t>, std::vector<uint32_t>> specific_chars(const std::vector<std::string>& strings) {
	const uint32_t string_count = strings.size();
    std::vector<uint32_t> result_1(3, 0);
    std::vector<uint32_t> uniques(3, 0);
    for ( uint32_t i = 0; i < string_count; ++i ) {
    	std::unordered_map<char, uint32_t> char_counts;
    	for ( const char& ch : strings[i] ) {
    		char_counts[ch]++;
    	}
    	uniques[i] = char_counts.size();
    	uint32_t specific_char_count = 0;
		for ( const auto& [key, value] : char_counts ) {
			if ( value != 2 ) {
				continue;
			}

			bool in_other_string = false;
			for ( uint32_t j = 0; j < string_count; ++j ) {
				if ( i != j && strings[j].find(key) != std::string::npos ) {
					in_other_string = true;
					break;
				}
			}
			if ( ! in_other_string ) {
				specific_char_count++;
			}
		}
		result_1[i] = specific_char_count;
    }
    std::vector<uint32_t> result_2(3);
    for ( uint32_t i = 0; i < string_count; ++i ) {
    	result_2[i] = uniques[i] - result_1[i];
    }
    return std::make_pair(result_1, result_2);
}

int main() {
	const auto [first, second] = specific_chars({ "ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr" });

	for ( const uint32_t& number : first ) {
		std::cout << number << " ";
	}
	std::cout << std::endl;
	for ( const uint32_t& number : second ) {
		std::cout << number << " ";
	}
	std::cout << std::endl;
}
