#include <iostream>
#include <numeric>
#include <functional>
#include <vector>

int main() {
	std::vector<int> nums = { 1, 2, 3, 4, 5 };
	auto nums_added = std::accumulate(std::begin(nums), std::end(nums), 0, std::plus<int>());
	auto nums_other = std::accumulate(std::begin(nums), std::end(nums), 0, [](const int& a, const int& b) {
		return a + 2 * b;
	});
	std::cout << "nums_added: " << nums_added << std::endl;
	std::cout << "nums_other: " << nums_other << std::endl;
}
