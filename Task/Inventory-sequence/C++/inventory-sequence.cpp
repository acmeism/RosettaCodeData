#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <vector>

std::vector<uint32_t> inventory_sequence(uint32_t max_term) {
	uint32_t term = 0;
	std::vector<uint32_t> result = { term };
	std::map<uint32_t, uint32_t> inventory = { { term, 1 } };
	while ( result.back() < max_term ) {
		inventory.insert({ term, 0 });
		const uint32_t count = inventory[term];
		term = ( count == 0 ) ? 0 : term + 1;
		if ( inventory.find(count) == inventory.end() ) {
			inventory.emplace(count, 1);
		} else {
			inventory[count]++;
		}
		result.emplace_back(count);
	}
	return result;
}

int main() {
	std::vector<uint32_t> sequence = inventory_sequence(10'000);

	uint32_t thousands = 1'000;
	std::cout << "The first 100 numbers of the inventory sequence:" << "\n";
	for ( uint64_t i = 0; i < sequence.size(); ++i ) {
		const uint32_t number = sequence[i];
		if ( i < 100 ) {
			std::cout << std::setw(2) << number << ( i % 20 == 19 ? "\n" : " " );
		} else if ( i == 100 ) {
			std::cout << "\n";
		} else if ( number >= thousands ) {
			std::cout << "The first element ≥ " << std::setw(5) << thousands << " is "
					  << std::setw(5) << number << " which occurs at index " << std::setw(6) << i << "\n";
		thousands += 1'000;
		}
	}
}
