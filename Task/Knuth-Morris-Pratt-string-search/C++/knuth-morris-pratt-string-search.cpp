#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size(); ++i ) {
		std::cout << vec[i];
		if ( i < vec.size() - 1 ) {
			std::cout << ", ";
		}
	}
	std::cout << "]" << std::endl;
}

std::vector<uint32_t> construct_LPS(const std::string& pattern) {
	std::vector<uint32_t> lps(pattern.length(), 0);
	uint32_t length = 0;
	uint32_t patternIndex = 1;

	while ( patternIndex < pattern.length() ) {
		if ( pattern[patternIndex] == pattern[length] ) {
			length++;
			lps[patternIndex] = length;
			patternIndex++;
		} else {
			if ( length != 0 ) {
				length = lps[length - 1];
			} else {
				lps[patternIndex] = 0;
				patternIndex++;
			}
		}
	}

	return lps;
}

std::vector<uint32_t> kmp_search(const std::string& pattern, const std::string text) {
	std::vector<uint32_t> result{};
	const std::vector<uint32_t> lps = construct_LPS(pattern);

	uint32_t textIndex = 0;
	uint32_t patternIndex = 0;

	while ( textIndex < text.length() ) {
		if ( text[textIndex] == pattern[patternIndex] ) {
			textIndex++;
			patternIndex++;
			if ( patternIndex == pattern.length() ) {
				result.emplace_back(textIndex - patternIndex);
				patternIndex = lps[patternIndex - 1];
			}
		} else {
			if ( patternIndex != 0 ) {
				patternIndex = lps[patternIndex - 1];
			} else {
				textIndex++;
			}
		}
	}

	return result;
}

int main() {
	const std::vector<std::string> texts = {
		"GCTAGCTCTACGAGTCTA",
		"GGCTATAATGCGTA",
		"there would have been a time for such a word",
		"needle need noodle needle",		"InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
"Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
	};

	const std::vector<std::string> patterns = { "TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa" };

	for ( uint32_t i = 0; i < texts.size(); ++i ) {
		std::cout << "Text" << i + 1 << " = " << texts[i] << std::endl;
	}
	std::cout << std::endl;

	for ( uint32_t i = 0; i < patterns.size(); ++i ) {
		const uint32_t j = ( i < 5 ) ? i : i - 1;
		std::vector<uint32_t> result = kmp_search(patterns[i], texts[j]);
		std::cout <<"Found '" << patterns[i] << "' in 'Text" << j + 1 << "' at indices "; print_vector(result);
	}
}
