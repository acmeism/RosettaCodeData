#include <algorithm>
#include <cstdint>
#include <experimental/iterator>
#include <functional>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

void display(const std::vector<int32_t>& numbers) {
	std::cout << "[";
    std::copy(std::begin(numbers), std::end(numbers), std::experimental::make_ostream_joiner(std::cout, ", "));
    std::cout << "]" << std::endl;
}

int32_t string_search_single(const std::string& haystack, const std::string& needle) {
	auto it = std::search(haystack.begin(), haystack.end(), std::boyer_moore_searcher(needle.begin(), needle.end()));

	if ( it != haystack.end() ) {
		return std::distance(haystack.begin(), it);
	}
	return -1;
}

std::vector<int32_t> string_search(const std::string& haystack, const std::string& needle) {
	std::vector<int32_t> result = {};
	uint64_t start = 0;
	int32_t index = 0;
	while ( index >= 0 && start < haystack.length() ) {
		std::string haystackReduced = haystack.substr(start);
		index = string_search_single(haystackReduced, needle);
		if ( index >= 0 ) {
			result.push_back(start + index);
			start += index + needle.length();
		}
	}
	return result;
}

int main() {
	const std::vector<std::string> texts = {
		"GCTAGCTCTACGAGTCTA",
		"GGCTATAATGCGTA",
		"there would have been a time for such a word",
		"needle need noodle needle",
		"DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
		"Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
	};

	const std::vector<std::string> patterns = { "TCTA", "TAATAAA", "word", "needle", "and", "alfalfa" };

	for ( uint64_t i = 0; i < texts.size(); ++i ) {
		std::cout << "text" << ( i + 1 ) << " = " << texts[i] << std::endl;
	}
	std::cout << std::endl;

	for ( uint64_t i = 0; i < texts.size(); ++i ) {
        std::vector<int32_t> indexes = string_search(texts[i], patterns[i]);
		std::cout << "Found " << std::quoted(patterns[i]) << " in 'text" << ( i + 1 ) << "' at indexes ";
		display(string_search(texts[i], patterns[i]));
	}
}
