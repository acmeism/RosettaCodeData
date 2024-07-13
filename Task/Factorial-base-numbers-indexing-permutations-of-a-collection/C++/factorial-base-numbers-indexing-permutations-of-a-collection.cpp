#include <cstdint>
#include <iostream>
#include <random>
#include <sstream>
#include <string>
#include <vector>

std::string stringify(const std::string& text) {
	return text;
}

std::string stringify(const uint32_t& number) {
	return std::to_string(number);
}

template<typename T>
std::string to_string(const std::vector<T>& factoradic, const std::string& delimiter) {
	std::string result = "";
	for ( uint32_t i = 0; i < factoradic.size() - 1; ++i ) {
		result += stringify(factoradic[i]) + delimiter;
	}
	result += stringify(factoradic.back());
	return result;
}

uint32_t factorial(const uint32_t& n) {
	uint32_t factorial = 1;
	for ( uint32_t i = 2; i <= n; ++i ) {
		factorial *= i;
	}
	return factorial;
}

void increment(std::vector<uint32_t>& factoradic) {
	uint64_t index = factoradic.size() - 1;
	while ( index >= 0 && factoradic[index] == factoradic.size() - index ) {
		factoradic[index] = 0;
		index -= 1;
	}
	if ( index >= 0 ) {
		factoradic[index] += 1;
	}
}

std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> lines;
	std::istringstream stream(text);
	std::string line;
	while ( std::getline(stream, line, delimiter) ) {
	    if ( ! line.empty() ) {
	        lines.emplace_back(line);
        }
	}
    return lines;
}

std::vector<uint32_t> convert_to_vector_of_integer(const std::string& text) {
	std::vector<uint32_t> result = { };
	std::vector<std::string> numbers = split_string(text, '.');
	for ( const std::string& number : numbers ) {
		result.emplace_back(std::stoi(number));
	}
	return result;
}

template <typename T>
std::vector<T> permutation(std::vector<T> elements, const std::vector<uint32_t>& factoradic) {
	uint32_t m = 0;
	for ( const uint32_t& g : factoradic ) {
		const T element = elements[m + g];
		elements.erase(elements.begin() + m + g);
		elements.insert(elements.begin() + m, element);
		m += 1;
	}
	return elements;
}

int main() {
	// Part 1
	std::vector<uint32_t> elements = convert_to_vector_of_integer("0.1.2.3");
	std::vector<uint32_t> factoradic = convert_to_vector_of_integer("0.0.0");
	for ( uint32_t i = 0; i < factorial(4); ++i ) {
		std::vector<uint32_t> rotated = permutation<uint32_t>(elements, factoradic);
		std::cout << to_string<uint32_t>(factoradic, ".") + " --> " + to_string<uint32_t>(rotated, " ") << std::endl;
		increment(factoradic);
	}
	std::cout << std::endl;

	// Part 2
	std::cout << "Generating the permutations of 11 digits:" << std::endl;
	const uint32_t limit = factorial(11);
	elements = convert_to_vector_of_integer("0.1.2.3.4.5.6.7.8.9.10");
	factoradic = convert_to_vector_of_integer("0.0.0.0.0.0.0.0.0.0");
	for ( uint32_t i = 0; i < limit; ++i ) {
		std::vector<uint32_t> rotated = permutation<uint32_t>(elements, factoradic);
		if ( i < 3 || i > limit - 4 ) {
			std::cout << to_string<uint32_t>(factoradic, ".") + " --> " + to_string<uint32_t>(rotated, " ")
                      << std::endl;
		} else if ( i == 3 ) {
			std::cout << " [ ... ] " << std::endl;
		}
		increment(factoradic);
	}
	std::cout << "Number of permutations is 11! = " << limit << std::endl << std::endl;

	// Part 3
	std::vector<std::string> codes = { "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
"51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1" };

	std::vector<std::string> cards = { "A♠", "K♠", "Q♠", "J♠", "10♠", "9♠", "8♠", "7♠", "6♠", "5♠", "4♠", "3♠", "2♠",
			           				   "A♥", "K♥", "Q♥", "J♥", "10♥", "9♥", "8♥", "7♥", "6♥", "5♥", "4♥", "3♥", "2♥",
			           				   "A♦", "K♦", "Q♦", "J♦", "10♦", "9♦", "8♦", "7♦", "6♦", "5♦", "4♦", "3♦", "2♦",
			           				   "A♣", "K♣", "Q♣", "J♣", "10♣", "9♣", "8♣", "7♣", "6♣", "5♣", "4♣", "3♣", "2♣"
                                     };

	std::cout << "Original deck of cards:" << std::endl;
	std::cout << to_string<std::string>(cards, " ") << std::endl << std::endl;
	std::cout << "Task shuffles:" << std::endl;
	for ( const std::string& code : codes ) {
		std::cout << code + " --> " << std::endl;
		factoradic = convert_to_vector_of_integer(code);
		std::cout << to_string<std::string>(permutation<std::string>(cards, factoradic), " ")
                  << std::endl << std::endl;
	}

	std::cout << "Random shuffle:" << std::endl;;
	std::random_device random;
	std::mt19937 generator(random());

	factoradic.clear();
	for ( uint32_t i = 0; i < cards.size() - 1; ++i ) {
		std::uniform_int_distribution<uint64_t> distribution(0, cards.size() - i - 1);
		factoradic.emplace_back(distribution(generator));
	}

	std::cout << to_string<uint32_t>(factoradic, ".") + " --> " << std::endl;
	std::cout << to_string<std::string>(permutation<std::string>(cards, factoradic), " ") << std::endl;
}
