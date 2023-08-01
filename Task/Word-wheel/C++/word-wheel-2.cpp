#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int main() {
	const std::string word_wheel_letters = "ndeokgelw";
	const std::string middle_letter = word_wheel_letters.substr(4, 1);

	std::vector<std::string> words;
	std::fstream file_stream;
	file_stream.open("../unixdict.txt");
	std::string word;
	while ( file_stream >> word ) {
		words.emplace_back(word);
	}

	std::vector<std::string> correct_words;
	for ( const std::string& word : words ) {
		if ( 3 <= word.length() && word.length() <= 9 &&
			word.find(middle_letter) != std::string::npos &&
			word.find_first_not_of(word_wheel_letters) == std::string::npos ) {

			correct_words.emplace_back(word);
		}
	}

	for ( const std::string& correct_word : correct_words ) {
		std::cout << correct_word << std::endl;
	}

	int32_t max_words_found = 0;
	std::vector<std::string> best_words9;
	std::vector<char> best_central_letters;
	std::vector<std::string> words9;
	for ( const std::string& word : words ) {
		if ( word.length() == 9 ) {
			words9.emplace_back(word);
		}
	}

	for ( const std::string& word9 : words9 ) {
		std::vector<char> distinct_letters(word9.begin(), word9.end());
		std::sort(distinct_letters.begin(), distinct_letters.end());
		distinct_letters.erase(std::unique(distinct_letters.begin(), distinct_letters.end()), distinct_letters.end());

		for ( const char& letter : distinct_letters ) {
			int32_t words_found = 0;
			for ( const std::string& word : words ) {
				if ( word.length() >= 3 && word.find(letter) != std::string::npos ) {
					std::vector<char> letters = distinct_letters;
					bool valid_word = true;
					for ( const char& ch : word ) {
						std::vector<char>::iterator iter = std::find(letters.begin(), letters.end(), ch);
						int32_t index = ( iter == letters.end() ) ? -1 : std::distance(letters.begin(), iter);
						if ( index == -1 ) {
							valid_word = false;
							break;
						}
						letters.erase(letters.begin() + index);
					}
					if ( valid_word ) {
						words_found++;
					}
				}
			}

			if ( words_found > max_words_found ) {
				max_words_found = words_found;
				best_words9.clear();
				best_words9.emplace_back(word9);
				best_central_letters.clear();
				best_central_letters.emplace_back(letter);
			} else if ( words_found == max_words_found ) {
				best_words9.emplace_back(word9);
				best_central_letters.emplace_back(letter);
			}
		}
	}

	std::cout << "\n" << "Most words found = " << max_words_found << std::endl;
	std::cout << "The nine letter words producing this total are:" << std::endl;
	for ( uint64_t i = 0; i < best_words9.size(); ++i ) {
		std::cout << best_words9[i] << " with central letter '" << best_central_letters[i] << "'" << std::endl;
	}
}
