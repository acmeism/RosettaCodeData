#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <unordered_map>
#include <vector>

constexpr int64_t LIMIT = pow(2, 53);

std::set<int64_t> jordan_polya_set;
std::unordered_map<int64_t, std::map<int32_t, int32_t>> decompositions;

std::string toString(const std::map<int32_t, int32_t>& a_map) {
	std::string result;
	for ( const auto& [key, value] : a_map ) {
		result = std::to_string(key) + "!" + ( value == 1 ? "" : "^" + std::to_string(value) ) + " * " + result;
	}
	return result.substr(0, result.length() - 3);
}

std::vector<int64_t> set_to_vector(const std::set<int64_t>& a_set) {
    std::vector<int64_t> result;
    result.reserve(a_set.size());

    for ( const int64_t& element : a_set ) {
        result.emplace_back(element);
    }
    return result;
}

void insert_or_update(std::map<int32_t, int32_t>& map, const int32_t& entry) {
	if ( map.find(entry) == map.end() ) {
		map.emplace(entry, 1);
	} else {
		map[entry]++;
	}
}

void create_jordan_polya() {
	jordan_polya_set.emplace(1);
	decompositions[1] = std::map<int32_t, int32_t>();
	int64_t factorial = 1;

	for ( int32_t multiplier = 2; multiplier <= 20; ++multiplier ) {
		factorial *= multiplier;
		for ( int64_t number : jordan_polya_set ) {
			while ( number <= LIMIT / factorial ) {
				int64_t original = number;
				number *= factorial;
				jordan_polya_set.emplace(number);
				decompositions[number] = decompositions[original];
				insert_or_update(decompositions[number], multiplier);
			}
		}
	}
}

int main() {
	create_jordan_polya();

	std::vector<int64_t> jordan_polya = set_to_vector(jordan_polya_set);

	std::cout << "The first 50 Jordan-Polya numbers:" << std::endl;
	for ( int64_t i = 0; i < 50; ++i ) {
		std::cout << std::setw(5) << jordan_polya[i] << ( i % 10 == 9 ? "\n" : "" );
	}

	const std::vector<int64_t>::iterator hundred_million =
		std::lower_bound(jordan_polya.begin(), jordan_polya.end(), 100'000'000);
	std::cout << "\n" << "The largest Jordan-Polya number less than 100 million: "
			  << jordan_polya[(hundred_million - jordan_polya.begin() - 1)] << std::endl << std::endl;

	for ( int32_t i : { 800, 1050, 1800, 2800, 3800 } ) {
		std::cout << "The " << i << "th Jordan-Polya number is: " << jordan_polya[i - 1]
			      << " = " << toString(decompositions[jordan_polya[i - 1]]) << std::endl;
	}
}
