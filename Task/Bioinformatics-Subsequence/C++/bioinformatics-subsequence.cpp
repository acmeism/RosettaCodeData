#include <cstdint>
#include <iostream>
#include <random>
#include <string>
#include <vector>

std::random_device random;
std::mt19937 generator(random());

std::string random_DNA(const uint32_t& length) {
	const std::vector<std::string> bases = { "A", "C", "G", "T" };
	std::uniform_int_distribution<int32_t> distribution(0, 3);

	std::string result;
	for ( uint32_t i = 0; i < length; ++i ) {
		result += bases[distribution(generator)];
	}
	return result;
}

void all_indexes(const std::string& text, const std::string& word) {
	std::string::size_type start = 0;
	while ( std::string::npos != ( start = text.find(word, start) ) ) {
		std::cout << start << " ";
	    start++;
	}
	std::cout << std::endl;
}

int main() {
	const std::string dna = random_DNA(200);
	const std::string subsequence = random_DNA(4);

	std::cout << "DNA sequence:" << std::endl;
	std::cout << dna << std::endl;
	std::cout << "Subsequence to locate: " << subsequence << std::endl;
	std::cout << "Matches found starting at the following indexes: ";
	all_indexes(dna, subsequence);
}
