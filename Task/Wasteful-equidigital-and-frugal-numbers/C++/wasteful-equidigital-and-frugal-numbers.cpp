#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

enum Category { WASTEFUL, EQUIDIGITAL, FRUGAL };
const std::vector<Category> categories = { Category::WASTEFUL, Category::EQUIDIGITAL, Category::FRUGAL };

struct Count {
	uint32_t lower_count;
	uint32_t upper_count;
};

std::vector<std::unordered_map<uint32_t,uint32_t>> factors;

std::string to_string(const Category& category) {
	std::string result;
	switch ( category ) {
		case Category::WASTEFUL    : result = "wasteful";    break;
		case Category::EQUIDIGITAL : result = "equidigital"; break;
		case Category::FRUGAL      : result = "frugal";      break;
	}
	return result;
}

/**
 * Return the number of digits in the given number written in the given base
 */
uint32_t digit_count(uint32_t number, const uint32_t& base) {
	uint32_t result = 0;
	while ( number != 0 ) {
		result++;
		number /= base;
	}
	return result;
}

/**
 * Return the total number of digits used in the prime factorisation
 * of the given number written in the given base
 */
uint32_t factor_count(const uint32_t& number, const uint32_t& base) {
	uint32_t result = 0;
	for ( const auto& [key, value] : factors[number] ) {
		result += digit_count(key, base);
		if ( value > 1 ) {
			result += digit_count(value, base);
		}
	}
	return result;
}

/**
 * Return the category of the given number written in the given base
 */
Category category(const uint32_t& number, const uint32_t& base) {
	const uint32_t digit = digit_count(number, base);
	const uint32_t factor = factor_count(number, base);
	return ( digit < factor ) ? Category::WASTEFUL :
		   ( digit > factor ) ? Category::FRUGAL : Category::EQUIDIGITAL;
}

/**
 * Factorise the numbers from 1 (inclusive) to limit (exclusive)
 */
void create_factors(const uint32_t& limit) {
	factors.assign(limit, std::unordered_map<uint32_t, uint32_t>());
	factors[1].emplace(1, 1);

	for ( uint32_t n = 1; n < limit; ++n ) {
		if ( factors[n].empty() ) {
			uint64_t n_copy = n;
			while ( n_copy < limit ) {
				for ( uint64_t i = n_copy; i < limit; i += n_copy ) {
					if ( factors[i].find(n) == factors[i].end() ) {
						factors[i].emplace(n, 1);
					} else {
						factors[i][n]++;
					}
				}
				n_copy *= n;
			}
		}
	}
}

int main() {
	create_factors(2'700'000);

	const uint32_t tiny_limit = 50;
	const uint32_t lower_limit = 10'000;
	const uint32_t upper_limit = 1'000'000;

	for ( uint32_t base : { 10, 11 } ) {
		std::unordered_map<Category, Count> counts = { { Category::WASTEFUL, Count(0, 0) },
			{ Category::EQUIDIGITAL, Count(0, 0) }, { Category::FRUGAL, Count(0,0) } };

		std::unordered_map<Category, std::vector<uint32_t>> lists = { { Category::WASTEFUL, std::vector<uint32_t>() },
			{ Category::EQUIDIGITAL, std::vector<uint32_t>() }, { Category::FRUGAL, std::vector<uint32_t>() } };

		uint32_t number = 1;
		std::cout << "FOR BASE " << base << ":" << std::endl << std::endl;
		while ( std::any_of(counts.begin(), counts.end(),
				[](const std::pair<Category, Count>& pair) { return pair.second.lower_count < lower_limit; }) ) {
			Category cat = category(number, base);
			if ( counts[cat].lower_count < tiny_limit || counts[cat].lower_count == lower_limit - 1 ) {
				lists[cat].emplace_back(number);
			}
			counts[cat].lower_count++;
			if ( number < upper_limit ) {
				counts[cat].upper_count++;
			}
			number++;
		}

		for ( const Category& category : categories ) {
			std::cout << "First " << tiny_limit << " " + to_string(category) << " numbers:" << std::endl;
			for ( uint32_t i = 0; i < tiny_limit; ++i ) {
				std::cout << std::setw(4) << lists[category][i] << ( i % 10 == 9 ? "\n" : " " );
			}
			std::cout << std::endl;
			std::cout << lower_limit << "th " << to_string(category) << " number: "
					  << lists[category][tiny_limit] << std::endl << std::endl;
		}

		std::cout << "For natural numbers less than " << upper_limit << ", the breakdown is as follows:" << std::endl;
		std::cout << "    Wasteful numbers    : " << counts[Category::WASTEFUL].upper_count << std::endl;
		std::cout << "    Equidigital numbers : " << counts[Category::EQUIDIGITAL].upper_count << std::endl;
		std::cout << "    Frugal numbers      : " << counts[Category::FRUGAL].upper_count << std::endl << std::endl;
	}
}
