#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include <vector>

struct Pair {
	std::string latin;
	std::string english;
};

const std::vector<std::vector<std::string>> LATIN_ENDINGS = {
	{ "o", "as", "at", "amus", "atis", "ant" },
	{ "eo", "es", "et", "emus", "etis", "ent" },
	{ "o", "is", "it", "imus", "itis", "unt" },
	{ "io", "is", "it", "imus", "itis", "iunt" } };
const std::vector<std::string> INFINITIVE_ENDINGS = { "are", "ere", "ere", "ire" };
const std::vector<std::string> ENGLISH_PRONOUNS =
	{ "I", "you (singular)", "he, she or it", "we", "you (plural)", "they" };
const std::vector<std::string> ENGLISH_ENDINGS = { "", "", "s", "", "", "" };

int32_t index_of(const std::vector<std::string>& words, const std::string& word) {
    std::vector<std::string>::const_iterator iterator = std::find(words.begin(), words.end(), word);
    return ( iterator == words.end() ) ? -1 : std::distance(words.begin(), iterator);
}

void conjugate(const std::string& infinitive, const std::string& english) {
	if ( infinitive.size() < 4 ) {
		throw std::invalid_argument("Infinitive is too short for a regular verb.");
	}
	const std::string infinitive_ending = infinitive.substr(infinitive.length() - 3);
	const int32_t index = index_of(INFINITIVE_ENDINGS, infinitive_ending);
	if ( index < 0 ) {
		throw std::invalid_argument("Infinitive ending not recognised: " + infinitive_ending);
	}
	const std::string stem = infinitive.substr(0, infinitive.length() - 3);
	std::cout << "Present indicative tense, active voice, of '"
			  << infinitive << "' to '" << english << "':" << std::endl;
	for ( uint32_t i = 0; i < ENGLISH_PRONOUNS.size(); ++i ) {
		std::cout << std::left << std::setw(15) <<  "    " + stem + LATIN_ENDINGS[index][i]
			<< " " + ENGLISH_PRONOUNS[i] + " " + english + ENGLISH_ENDINGS[i] << std::endl;
	}
	std::cout << std::endl;
}

int main() {
	const std::vector<Pair> pairs = { { "amare", "love" },
		{ "videre", "see" }, { "ducere", "lead" }, { "audire", "hear" } };
	std::for_each(pairs.begin(), pairs.end(), [](const Pair& pair) { conjugate(pair.latin, pair.english); });
}
