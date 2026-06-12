#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

struct Test {
	std::string file_name;
	std::string letters;
	uint32_t min;
};

bool isIncremental(const std::string& word, const std::string& letters, const uint32_t& min) {
    std::vector<uint32_t> counts(3, 0);
    for ( const char& ch : word ) {
    	for ( uint32_t i = 0; i < letters.size(); ++i ) {
    		if ( ch == letters[i] ) {
    			counts[i]++;
    		}
    	}
    }
    std::sort(counts.begin(), counts.end());

    const uint32_t min_count = counts[0];
    return min_count >= min && counts[1] == min_count + 1 && counts[2] == min_count + 2;
}

int main() {
	const std::vector<Test> tests = { Test("../unixdict.txt", "abc", 1), Test("../unixdict.txt", "cio", 2),
									  Test("../words_alpha.txt", "the", 2), Test("../words_alpha.txt", "cio", 3) };

	for ( Test test : tests ) {
		std::cout << "\n" << "Filtering the file '" << test.file_name.substr(3) << "' for the letters '"
			<< test.letters << "' with a minimum occurrence of " << test.min << ":" << std::endl;

		std::ifstream in_stream(test.file_name);
		std::string word;
		while ( std::getline(in_stream, word) ) {
		    if ( isIncremental(word, test.letters, test.min) ) {
			    std::cout << "    " << word << std::endl;
		    }
		}
		in_stream.close();
	}
}
