#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <set>
#include <string>
#include <unordered_map>

struct Isogram_pair {
	std::string word;
	int32_t value;
};

std::string to_lower_case(const std::string& text) {
	std::string result = text;
	std::transform(result.begin(), result.end(), result.begin(),
		[](char ch){ return std::tolower(ch); });
	return result;
}

int32_t isogram_value(const std::string& word) {
	std::unordered_map<char, int32_t> char_counts;
	for ( const char& ch : word ) {
		if ( char_counts.find(ch) == char_counts.end() ) {
			char_counts.emplace(ch, 1);
		} else {
			char_counts[ch]++;
		}
	}

	const int32_t count = char_counts[word[0]];
	const bool identical = std::all_of(char_counts.begin(), char_counts.end(),
	                       	   [count](const std::pair<char, int32_t> pair){ return pair.second == count; });

	return identical ? count : 0;
}

int main() {
	auto compare = [](Isogram_pair a, Isogram_pair b) {
		return ( a.value == b.value ) ?
			( ( a.word.length() == b.word.length() ) ? a.word < b.word : a.word.length() > b.word.length() )
			: a.value > b.value;
	};
	std::set<Isogram_pair, decltype(compare)> isograms;

	std::fstream file_stream;
	file_stream.open("../unixdict.txt");
	std::string word;
	while ( file_stream >> word ) {
		const int32_t value = isogram_value(to_lower_case(word));
		if ( value > 1 || ( word.length() > 10 && value == 1 ) ) {
			isograms.insert(Isogram_pair(word, value));
		}
	}

	std::cout << "n-isograms with n > 1:" << std::endl;
	for ( const Isogram_pair& isogram_pair : isograms ) {
		if ( isogram_pair.value > 1 ) {
			std::cout << isogram_pair.word << std::endl;
		}
	}

	std::cout << "\n" << "Heterograms with more than 10 letters:" << std::endl;
	for ( const Isogram_pair& isogram_pair : isograms ) {
		if ( isogram_pair.value == 1 ) {
			std::cout << isogram_pair.word << std::endl;
		}
	}
}
