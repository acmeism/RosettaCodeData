#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <random>
#include <vector>

int main() {
	std::vector<uint32_t> numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };

	std::random_device random;
	std::mt19937 generator(random());

	std::shuffle(numbers.begin(), numbers.end(), generator);

	std::copy(numbers.begin(), numbers.end(), std::ostream_iterator<uint32_t>(std::cout, " "));
	std::cout << std::endl;
}
