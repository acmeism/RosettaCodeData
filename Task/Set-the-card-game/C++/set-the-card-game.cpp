#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <string>
#include <unordered_set>
#include <vector>

const std::vector<std::string> numbers { "ONE", "TWO", "THREE" };
const std::vector<std::string> colours { "GREEN", "RED", "PURPLE" };
const std::vector<std::string> shadings { "OPEN", "SOLID", "SRIPED" };
const std::vector<std::string> shapes { "DIAMOND", "OVAL", "SQUIGGLE" };

typedef std::vector<std::string> Card;

std::vector<Card> create_pack_of_cards() {
	std::vector<Card> pack;
	for ( std::string number : numbers ) {
		for  ( std::string colour : colours ) {
			for ( std::string shading : shadings ) {
				for ( std::string shape : shapes ) {
					Card card = { number, colour, shading, shape };
					pack.emplace_back(card);
				}
			}
		}
	}
	return pack;
}

bool all_same_or_all_different(const std::vector<Card>& triple, const int32_t& index) {
	std::unordered_set<std::string> triple_set;
	for ( const Card& card : triple ) {
		triple_set.insert(card[index]);
	}
	return triple_set.size() == 1 || triple_set.size() == 3;
}

bool is_game_set(const std::vector<Card>& triple) {
	return all_same_or_all_different(triple, 0) &&
		   all_same_or_all_different(triple, 1) &&
		   all_same_or_all_different(triple, 2) &&
		   all_same_or_all_different(triple, 3);
}

template <typename T>
std::vector<std::vector<T>> combinations(const std::vector<T>& list, const int32_t& choose) {
	std::vector<std::vector<T>> combinations;
	std::vector<uint64_t> combination(choose);
	std::iota(combination.begin(), combination.end(), 0);

	while ( combination[choose - 1] < list.size() ) {
		std::vector<T> entry;
		for ( const uint64_t& value : combination ) {
			entry.emplace_back(list[value]);
		}
		combinations.emplace_back(entry);

		int32_t temp = choose - 1;
		while ( temp != 0 && combination[temp] == list.size() - choose + temp ) {
			temp--;
		}
		combination[temp]++;
		for ( int32_t i = temp + 1; i < choose; ++i ) {
			combination[i] = combination[i - 1] + 1;
		}
	}
	return combinations;
}

int main() {
	std::random_device rand;
	std::mt19937 mersenne_twister(rand());

	std::vector<Card> pack = create_pack_of_cards();
	for ( const int32_t& card_count : { 4, 8, 12 } ) {
		std::shuffle(pack.begin(), pack.end(), mersenne_twister);
		std::vector<Card> deal(pack.begin(), pack.begin() + card_count);
		std::cout << "Cards dealt: " << card_count << std::endl;
		for ( const Card& card : deal ) {
			std::cout << "[" << card[0] << " " << card[1] << " " << card[2] << " " << card[3] << "]" << std::endl;
		}
		std::cout << std::endl;

		std::cout << "Sets found: " << std::endl;
		for ( const std::vector<Card>& combination : combinations(deal, 3) ) {
			if ( is_game_set(combination) ) {
				for ( const Card& card : combination ) {
					std::cout << "[" << card[0] << " " << card[1] << " " << card[2] << " " << card[3] << "] ";
				}
				std::cout << std::endl;
			}
		}
		std::cout << "-------------------------" << std::endl << std::endl;
	}
}
