#include <exception>
#include <iostream>
#include <string>
#include <vector>

char sentence_type(const std::string& sentence) {
	if ( sentence.empty() ) {
		throw std::invalid_argument("Cannot classify an empty sentence");
	}

	char result;
	const char last_character = sentence.back();
	switch (last_character) {
		case '?': result = 'Q'; break;
		case '.': result = 'S'; break;
		case '!': result = 'E'; break;
		default:  result = 'N'; break;
	};
	return result;
}

int main() {
	const std::vector<std::string> sentences = { "hi there, how are you today?",
									  	  	     "I'd like to present to you the washing machine 9001.",
												 "You have been nominated to win one of these!",
												 "Just make sure you don't break it" };

	for ( const std::string& sentence : sentences ) {
		std::cout << sentence << " -> " << sentence_type(sentence) << std::endl;
	}
}
