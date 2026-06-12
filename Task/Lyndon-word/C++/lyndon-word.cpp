#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

// Return the index of the given element in the given vector
int32_t index_of(const std::vector<std::string>& words, const std::string& word) {
    std::vector<std::string>::const_iterator iterator = std::find(words.begin(), words.end(), word);
    return ( iterator == words.end() ) ? -1 : std::distance(words.begin(), iterator);
}

// Using the Duval (1988) algorithm
std::string next_word(const uint32_t& max_length, const std::string& word, const std::vector<std::string>& alphabet) {
	// Step 1: Repeat the word and truncate
	std::string next_word = word;
	while ( next_word.size() < max_length ) {
		next_word += word;
	}
	next_word = next_word.substr(0, max_length);

	// Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
	const std::string alphabet_last_symbol = alphabet.back();
	while ( next_word.ends_with(alphabet_last_symbol) ) {
		next_word = next_word.substr(0, next_word.size() - 1);
	}

	// Step 3: Replace the last symbol of the next word by its successor in the alphabet
	if ( ! next_word.empty() ) {
		const std::string word_last_symbol = next_word.substr(next_word.size() - 1);
		const uint32_t index = index_of(alphabet, word_last_symbol) + 1;
		next_word.replace(next_word.size() - 1, 1, alphabet[index]);
	}
	return next_word;
}

int main() {
	const std::vector<std::string> alphabet = { "0", "1" };
	std::string word = alphabet.front();
	while ( ! word.empty() ) {
		std:: cout << word << std::endl;
		word = next_word(5, word, alphabet);
	}
}
