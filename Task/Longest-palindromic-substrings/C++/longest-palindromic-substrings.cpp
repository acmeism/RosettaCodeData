#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

/**
 * Return the longest palindromic substrings of the given string.
 *
 * Uses Manacher's algorithm; for more information visit
 * https://cp-algorithms.com/string/manacher.html
 */
std::vector<std::string> manacher(const std::string& text) {
	std::vector<std::string> result;
	if ( text.empty() ) {
		return result;
	}

	std::string word = "#";
	for ( const char& ch : text ) {
		word += std::string(1, ch) + "#";
	}
	word = "$" + word + "@";

	std::vector<uint32_t> pals(word.length(), 0);
	uint32_t centre = 1;
	uint32_t right = 1;

	for ( uint32_t i = 2; i < word.length() - 1; ++i ) {
		if ( right > i && pals[2 * centre - i] > 0 ) {
            pals[i] = 1;
        }

		while ( word[i + pals[i] + 1] == word[i - pals[i] - 1] ) {
			pals[i]++;
		}

		if ( i + pals[i] > right ) {
			centre = i;
			right = i + pals[i];
		}
	}

	uint32_t max_length = 0;
	std::vector<uint32_t> indexes;
	for ( uint32_t index = 0; index < pals.size(); ++index ) {
		if ( pals[index] > max_length ) {
			max_length = pals[index];
			indexes.clear();
			indexes.emplace_back(index);
		} else if ( pals[index] == max_length ) {
			indexes.emplace_back(index);
		}
	}

	for ( const uint32_t& index : indexes ) {
		const uint32_t begin = ( index - max_length ) / 2;
		result.emplace_back(text.substr(begin, max_length));
	}

	return result;
}

int main() {
	std::vector<std::string> tests = { "three old rotators",
									   "never reverse",
									   "stable was I ere I saw elbatrosses",
									   "abracadabra",
									   "drome",
									   "the abbatial palace",
									   "",
									   "aabccdeff" };

	for ( const std::string& test : tests ) {
		std::vector<std::string> result = manacher(test);
		std::cout << "The longest palindromic substrings of \"" << test << "\" are: [";
		for ( uint32_t i = 0; i < result.size(); ++i ) {
			std::cout << result[i];
			if ( i < result.size() - 1 ) {
				std::cout << ", ";
			}
		}
		std::cout << "]" << std::endl;
	}
}
