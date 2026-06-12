#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <ranges>
#include <vector>

int main() {
	const std::vector<int32_t> one = { 3, 4, 34, 25, 9, 12, 36, 56, 36 };
	const std::vector<int32_t> two = { 2, 8, 81, 169, 34, 55, 76, 49, 7 };
	const std::vector<int32_t> three = { 75, 121, 75, 144, 35, 16, 46, 3 };

	std::vector<int32_t> concatenated(one.begin(), one.end());
	concatenated.insert(concatenated.end(), two.begin(), two.end());
	concatenated.insert(concatenated.end(), three.begin(), three.end());

	std::erase_if(concatenated,
		[](const int32_t& i) { return std::pow(static_cast<int32_t>(std::sqrt(i)), 2) != i; });

	std::sort(concatenated.begin(), concatenated.end());

	std::ranges::copy(concatenated, std::ostream_iterator<int32_t>(std::cout, " "));
}
