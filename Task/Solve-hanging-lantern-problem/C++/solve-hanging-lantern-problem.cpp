#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

void print_vector(const std::vector<uint32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]";
}

uint64_t factorial(const uint32_t& n) {
	return ( n == 0 ) ? 1 : n * factorial(n - 1);
}

uint64_t takedown_count(const std::vector<uint32_t>& numbers) {
	const uint32_t total = std::accumulate(numbers.begin(), numbers.end(), 0);
	uint64_t result = factorial(total);
	for ( const uint32_t& number : numbers ) {
		result = result / factorial(number);
	}
	return result;
}

void takedown_ways(const std::vector<uint32_t> numbers, const uint32_t& rowSize) {
	std::vector<uint32_t> limits(numbers.size(), 0);
	uint32_t sum = 0;
	std::vector<uint32_t> multi_numbers = { };
	for ( uint64_t i = 0; i < numbers.size(); ++i ) {
		sum += numbers[i];
		limits[i] = sum;
		for ( uint64_t j = 0; j < numbers[i]; ++j ) {
			multi_numbers.emplace_back(i + 1);
		}
	}

	const uint64_t takedown = takedown_count(numbers);
	std::cout << "List of " << takedown << " permutations for " << numbers.size()
		<< " groups with lanterns per group "; print_vector(numbers); std::cout << " :" << std::endl;
	uint32_t permutation_count = 0;
	do {
		std::vector<uint32_t> current(limits);
		std::vector<uint32_t> ways(sum, 0);
		for ( uint32_t i = 0; i < sum; ++i ) {
			ways[i] = current[multi_numbers[i] - 1];
			current[multi_numbers[i] - 1] -= 1;
		}
		print_vector(ways); std::cout << "  ";
		permutation_count += 1;
		if ( permutation_count % rowSize == 0 ) {
			std::cout << std::endl;
		}
	} while ( next_permutation(multi_numbers.begin(), multi_numbers.end()) );
}

int main() {
	const std::vector<std::vector<uint32_t>> tests = { { 1, 2, 3 }, { 2, 2, 3, 3 }, { 10, 2 } };
	std::cout << "Lantern arrangement => number of takedown ways:" << std::endl;
	std::for_each(tests.begin(), tests.end(), [](const std::vector<uint32_t>& numbers)
		{ print_vector(numbers); std::cout << " => " << takedown_count(numbers) << std::endl; });
	std::cout << std::endl;

	takedown_ways({ 1, 2, 3 }, 5);
}
