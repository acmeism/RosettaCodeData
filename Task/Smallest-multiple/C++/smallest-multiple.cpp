#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

int main() {
	std::vector<uint32_t> numbers(20);
	std::iota(numbers.begin(), numbers.end(), 1);

	const uint32_t smallest_multiple = std::reduce(numbers.begin(), numbers.end(), 1,
		[](const uint32_t& a, const uint32_t& b) { return std::lcm(a, b); });

	std::cout << smallest_multiple << std::endl;
}
