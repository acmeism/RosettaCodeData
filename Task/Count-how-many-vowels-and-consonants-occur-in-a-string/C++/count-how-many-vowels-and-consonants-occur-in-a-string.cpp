#include <cstdint>
#include <algorithm>
#include <iostream>
#include <set>
#include <string>
#include <vector>

struct Count {
	uint32_t vowel_total;
	uint32_t vowel_distinct;
	uint32_t consonant_total;
	uint32_t consonant_distinct;
};

const std::vector<char> vowels = { 'a', 'e', 'i', 'o', 'u' };

bool is_vowel(const char& ch) {
	return std::find(vowels.begin(), vowels.end(), ch) != vowels.end();
}

bool is_letter(const char& ch) {
	return ( ( ch >= 'a') && ( ch <= 'z' ) ) || ( ( ch >= 'A' ) && ( ch <= 'Z' ) );
}

bool is_consonant(const char& ch) {
	return is_letter(ch) && ! is_vowel(ch);
}

Count letter_count(const std::string& text) {
	std::set<char> vowel_set{};
	std::set<char> consonant_set{};
	uint32_t vowel_total = 0;
	uint32_t consonant_total = 0;
	for ( const char& ch : text ) {
		if ( is_vowel(ch) ) {
			vowel_total += 1;
			vowel_set.insert(std::tolower(ch));
		}
		if ( is_consonant(ch) ) {
			consonant_total += 1;
			consonant_set.insert(std::tolower(ch));
		}
	}
	return Count(vowel_total, vowel_set.size(), consonant_total, consonant_set.size());
}
int main() {
	const std::string test = "Now is the time for all good men to come to the aid of their country.";
	Count letters = letter_count(test);
	std::cout << "\"" << test << "\"" << std::endl;
	std::cout << "contains " << letters.vowel_total << " vowels (" << letters.vowel_distinct << " distinct) "
			  << "and " << letters.consonant_total << " consonants ("
			  << letters.consonant_distinct << " distinct)" << std::endl;
}
