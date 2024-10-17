#include <algorithm>
#include <cstdint>
#include <iostream>
#include <set>
#include <vector>

void print_vector(const std::vector<uint32_t>& list) {
    std::cout << "[";
    for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
    	std::cout << list[i] << ", ";
    }
    std::cout << list.back() << "]";
}

void display_table(const std::vector<std::vector<uint32_t>> table) {
	std::cout << "[";
	for ( uint64_t i = 0; i < table.size() - 1; ++i ) {
		print_vector(table[i]);
		std::cout << ", ";
	}
	print_vector(table.back());
	std::cout << "]" << "\n";
}

std::vector<std::vector<uint32_t>> four_face_combinations() {
	std::vector<std::vector<uint32_t>> result = { };
	std::set<uint32_t> found  = { };

	 for ( uint32_t i = 1; i <= 4; ++i ) {
		for ( uint32_t j = 1; j <= 4; ++j ) {
			for ( uint32_t k = 1; k <= 4; ++k ) {
				for ( uint32_t l = 1; l <= 4; ++l ) {
					std::vector<uint32_t> combo = { i, j, k, l };
					std::sort(combo.begin(), combo.end());

					const uint32_t key = 64 * combo[0] + 16 * combo[1] + 4 * combo[2] + combo[3];
					if ( found.insert(key).second ) {
						result.emplace_back(combo);
					}
				}
			}
		}
	}

	return result;
}

bool comparator(const std::vector<uint32_t>& one, const std::vector<uint32_t>& two) {
	uint32_t one_wins = 0;
	uint32_t two_wins = 0;
	for ( uint32_t i = 0; i < 4; ++i ) {
		for ( uint32_t j = 0; j < 4; ++j ) {
			if ( one[i] > two[j] ) {
				one_wins++;
			} else if ( one[i] < two[j] ) {
				two_wins++;
			}
		}
	}
	return ( one_wins < two_wins );
}

std::vector<std::vector<std::vector<uint32_t>>> find_intransitive_3(
		const std::vector<std::vector<uint32_t>>& combos) {
	std::vector<std::vector<std::vector<uint32_t>>> result = { };

	for ( uint64_t i = 0; i < combos.size(); ++i ) {
		for ( uint64_t j = 0; j < combos.size(); ++j ) {
			if ( comparator(combos[i], combos[j]) ) {
				for ( const std::vector<uint32_t>& combo : combos ) {
					if ( comparator(combos[j], combo) && comparator(combo, combos[i]) ) {
						std::vector<std::vector<uint32_t>> entry = { combos[i], combos[j], combo };
						result.emplace_back(entry);
					}
				}
			}
		}
	}

	return result;
}

std::vector<std::vector<std::vector<uint32_t>>> find_intransitive_4(
		const std::vector<std::vector<uint32_t>>& combos) {
	std::vector<std::vector<std::vector<uint32_t>>> result = { };

	for ( uint64_t i = 0; i < combos.size(); ++i ) {
		for ( uint64_t j = 0; j < combos.size(); ++j ) {
			if ( comparator(combos[i], combos[j]) ) {
				for ( uint64_t k = 0; k < combos.size(); ++k ) {
					if ( comparator(combos[j], combos[k]) ) {
						for ( const std::vector<uint32_t>& combo : combos ) {
							if ( comparator(combos[k], combo) && comparator(combo, combos[i]) ) {
								std::vector<std::vector<uint32_t>> entry =
									{ combos[i], combos[j], combos[k], combo };
								result.emplace_back(entry);
							}
						}
					}
				}
			}
		}
	}

	return result;
}

int main() {
	std::vector<std::vector<uint32_t>> combinations = four_face_combinations();
	std::cout << "The number of eligible 4-faced dice: " << combinations.size() << "\n\n";

	std::vector<std::vector<std::vector<uint32_t>>> intransitive_3 = find_intransitive_3(combinations);
	std::cout << intransitive_3.size() << " ordered lists of 3 non-transitive dice found, namely:" << "\n";
	for ( const std::vector<std::vector<uint32_t>>& table : intransitive_3 ) {
		display_table(table);
	}
	std::cout << "\n";

	std::vector<std::vector<std::vector<uint32_t>>> intransitive_4 = find_intransitive_4(combinations);
	std::cout << intransitive_4.size() << " ordered lists of 4 non-transitive dice found, namely:" << "\n";
	for ( const std::vector<std::vector<uint32_t>>& table : intransitive_4 ) {
		display_table(table);
	}
}
