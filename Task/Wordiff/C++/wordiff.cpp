#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <vector>

std::vector<std::string> request_player_names() {
	std::vector<std::string> player_names;
	std::string player_name;
	for ( uint32_t i = 0; i < 2; ++i ) {
		std::cout << "Please enter the player's name: ";
		std::getline(std::cin, player_name);
		player_names.emplace_back(player_name);
	}
	return player_names;
}

bool is_letter_removed(const std::string& previous_word, const std::string& current_word) {
	for ( uint64_t i = 0; i < previous_word.length(); ++i ) {
		if ( current_word == previous_word.substr(0, i) + previous_word.substr(i + 1) ) {
			return true;
		}
	}
	return false;
}

bool is_letter_added(const std::string& previous_word, const std::string& current_word) {
	return is_letter_removed(current_word, previous_word);
}

bool is_letter_changed(const std::string& previous_word, const std::string& current_word) {
	if ( previous_word.length() != current_word.length() ) {
		return false;
	}

	uint32_t difference_count = 0;
	for ( uint64_t i = 0; i < current_word.length(); ++i ) {
		difference_count += ( current_word[i] == previous_word[i] ) ? 0 : 1;
	}
	return difference_count == 1;
}

bool is_wordiff(const std::string& current_word,
		        const std::vector<std::string>& words_used,
				const std::vector<std::string>& dictionary) {
	if ( std::find(dictionary.begin(), dictionary.end(), current_word) == dictionary.end()
		|| std::find(words_used.begin(), words_used.end(), current_word) != words_used.end() ) {
		return false;
	}

	std::string previous_word = words_used.back();
	return is_letter_changed(previous_word, current_word)
		|| is_letter_removed(previous_word, current_word) || is_letter_added(previous_word, current_word);
}

std::vector<std::string> could_have_entered(const std::vector<std::string>& words_used,
										    const std::vector<std::string>& dictionary) {
	std::vector<std::string> result;
	for ( const std::string& word : dictionary ) {
		if ( std::find(words_used.begin(), words_used.end(), word) == words_used.end()
			&& is_wordiff(word, words_used, dictionary) ) {
			result.emplace_back(word);
		}
	}
	return result;
}

int main() {
	std::vector<std::string> dictionary;
	std::vector<std::string> starters;
	std::fstream file_stream;
	file_stream.open("../unixdict.txt");
	std::string word;
	while ( file_stream >> word ) {
		dictionary.emplace_back(word);
		if ( word.length() == 3 || word.length() == 4 ) {
			starters.emplace_back(word);
		}
	}

	std::random_device rand;
	std::mt19937 mersenne_twister(rand());
	std::shuffle(starters.begin(), starters.end(), mersenne_twister);
	std::vector<std::string> words_used;
	words_used.emplace_back(starters[0]);

	std::vector<std::string> player_names = request_player_names();
	bool playing = true;
	uint32_t playerIndex = 0;
	std::string current_word;
	std::cout << "The first word is: " << words_used.back() << std::endl;

	while ( playing ) {
		std::cout << player_names[playerIndex] << " enter your word: ";
		std::getline(std::cin, current_word);
		if ( is_wordiff(current_word, words_used, dictionary) ) {
			words_used.emplace_back(current_word);
			playerIndex = ( playerIndex == 0 ) ? 1 : 0;
		} else {
			std::cout << "You have lost the game, " << player_names[playerIndex] << std::endl;
			std::vector<std::string> missed_words = could_have_entered(words_used, dictionary);
			std::cout << "You could have entered: [";
			for ( uint64_t i = 0; i < missed_words.size() - 1; ++i ) {
				std::cout << missed_words[i] << ", ";
			}
			std::cout << missed_words.back() << "]" << std::endl;
			playing = false;
		}
	}
}
