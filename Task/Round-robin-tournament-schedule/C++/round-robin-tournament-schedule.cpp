#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <vector>

void round_robin(uint32_t team_count) {
	if ( team_count < 2 ) {
		throw std::invalid_argument("Number of teams must be greater than 2: " + team_count);
	}

	std::vector<uint32_t> rotating_list(team_count);
	std::iota(rotating_list.begin(), rotating_list.end(), 2);
	if ( team_count % 2 == 1 ) {
		rotating_list.emplace_back(0);
		team_count++;
	}

	for ( uint32_t round = 1; round < team_count; ++round ) {
		std::cout << "Round " << std::setw(2) << round << ":";
		std::vector<uint32_t> fixed_list(1, 1);
		fixed_list.insert(fixed_list.end(), rotating_list.begin(), rotating_list.end());
		for ( uint32_t i = 0; i < team_count / 2; ++i ) {
			std::cout << " ( " << std::setw(2) << fixed_list[i]
					  << " vs " << std::setw(2) << fixed_list[team_count - 1 - i] << " )";
		}
		std::cout << std::endl;
		std::rotate(rotating_list.rbegin(), rotating_list.rbegin() + 1, rotating_list.rend());
	}
}

int main() {
	std::cout << "Round robin for 12 players:" << std::endl;
	round_robin(12);
	std::cout << std::endl << std::endl;
	std::cout << "Round robin for 5 players, 0 denotes a bye:" << std::endl;
	round_robin(5);
}
