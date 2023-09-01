#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <random>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << " ";
	}
	std::cout << list.back() << "]" << std::endl;
}

int main() {
	std::vector<char> cards;
	for ( int32_t i = 0; i < 26; ++i ) {
		cards.emplace_back('R');
		cards.emplace_back('B');
	}

	std::random_device rand;
	std::mt19937 mersenne_twister(rand());
	std::shuffle(cards.begin(), cards.end(), mersenne_twister);

	std::vector<char> red_pile;
	std::vector<char> black_pile;
	std::vector<char> discard_pile;

	for ( int32_t i = 0; i < 52; i += 2 ) {
		if ( cards[i] == 'R' ) {
			red_pile.emplace_back(cards[i + 1]);
		} else {
			black_pile.emplace_back(cards[i + 1]);
		}
		discard_pile.emplace_back(cards[i]);
	}

	std::cout << "A sample run." << "\n" << std::endl;
	std::cout << "After dealing the cards the state of the piles is:" << std::endl;
	std::cout << "    Red    : " << std::setw(2) << red_pile.size() << " cards -> "; print_vector<char>(red_pile);
	std::cout << "    Black  : " << std::setw(2) << black_pile.size() << " cards -> "; print_vector<char>(black_pile);
	std::cout << "    Discard: " << std::setw(2) << discard_pile.size()
              << " cards -> "; print_vector<char>(discard_pile);

	const int32_t minimum_size = std::min(red_pile.size(), black_pile.size());
	std::uniform_int_distribution<int> uniform_random{ 1, minimum_size };
	const int32_t choice = uniform_random(mersenne_twister);

	std::vector<int32_t> red_indexes(red_pile.size());
	std::iota(red_indexes.begin(), red_indexes.end(), 0);
	std::vector<int32_t> black_indexes(black_pile.size());
	std::iota(black_indexes.begin(), black_indexes.end(), 0);

	std::shuffle(red_indexes.begin(), red_indexes.end(), mersenne_twister);
	std::shuffle(black_indexes.begin(), black_indexes.end(), mersenne_twister);

	std::vector<int32_t> red_chosen_indexes(red_indexes.begin(), red_indexes.begin() + choice);
	std::vector<int32_t> black_chosen_indexes(black_indexes.begin(), black_indexes.begin() + choice);

	std::cout << "\n" << "Number of cards are to be swapped: " << choice << std::endl;
	std::cout << "The respective zero-based indices of the cards to be swapped are:" << std::endl;
	std::cout << "    Red  : "; print_vector<int32_t>(red_chosen_indexes);
	std::cout << "    Black: "; print_vector<int32_t>(black_chosen_indexes);

	for ( int32_t i = 0; i < choice; ++i ) {
		const char temp = red_pile[red_chosen_indexes[i]];
		red_pile[red_chosen_indexes[i]] = black_pile[black_chosen_indexes[i]];
		black_pile[black_chosen_indexes[i]] = temp;
	}

	std::cout << "\n" << "After swapping cards the state of the red and black piles is:" << std::endl;
	std::cout << "    Red  : "; print_vector<char>(red_pile);
	std::cout << "    Black: "; print_vector<char>(black_pile);

	int32_t red_count = 0;
	for ( const char& ch : red_pile ) {
		if ( ch == 'R' ) {
			red_count++;
		}
	}

	int32_t black_count = 0;
	for ( const char& ch : black_pile ) {
		if ( ch == 'B' ) {
			black_count++;
		}
	}

	std::cout << "\n" << "The number of red cards in the red pile: " << red_count << std::endl;
	std::cout << "The number of black cards in the black pile: " << black_count << std::endl;
	if ( red_count == black_count ) {
		std::cout << "So the assertion is correct." << std::endl;
	} else {
		std::cout << "So the assertion is incorrect." << std::endl;
	}
}
