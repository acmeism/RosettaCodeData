#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <ranges>
#include <vector>

int main() {
	const std::vector<int32_t> numbers1{  5, 45, 23, 21, 67 };
	const std::vector<int32_t> numbers2{ 43, 22, 78, 46, 38 };
	const std::vector<int32_t> numbers3{  9, 98, 12, 98, 53 };

	std::vector<int32_t> numbers{};
	for ( uint32_t i = 0; i < 5; ++i ) {
		numbers.emplace_back(std::min({ numbers1[i], numbers2[i], numbers3[i] }));
	}

	std::ranges::copy(numbers, std::ostream_iterator<int32_t>(std::cout, " "));
}
