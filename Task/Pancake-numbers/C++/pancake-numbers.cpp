#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <numeric>
#include <queue>
#include <vector>

std::vector<uint32_t> flip_stack(std::vector<uint32_t> stack, const uint32_t& index) {
	std::reverse(stack.begin(), stack.begin() + index);
	return stack;
}

std::pair<std::vector<uint32_t>, uint32_t> pancake(const uint32_t& number) {
	std::vector<uint32_t> initial_stack(number);
	std::iota(initial_stack.begin(), initial_stack.end(), 1);
	std::map<std::vector<uint32_t>, uint32_t> stack_flips = { std::make_pair(initial_stack, 0) };
	std::queue<std::vector<uint32_t>> queue;
	queue.push(initial_stack);

	while ( ! queue.empty() ) {
		std::vector<uint32_t> stack = queue.front();
		queue.pop();

		const uint32_t flips = stack_flips[stack] + 1;
		for ( uint32_t i = 2; i <= number; ++i ) {
			std::vector<uint32_t> flipped = flip_stack(stack, i);
			if ( ! stack_flips.contains(flipped) ) {
				stack_flips[flipped] = flips;
				queue.push(flipped);
			}
		}
    }

	const auto ptr = std::max_element(stack_flips.begin(), stack_flips.end(),
		[](const auto& pair1, const auto& pair2){ return pair1.second < pair2.second; });

	return std::make_pair(ptr->first, ptr->second);
}

int main() {
	for ( uint32_t n = 1; n <= 9; ++n ) {
		std::pair<std::vector<uint32_t>, uint32_t> result = pancake(n);
		std::cout << "pancake(" << n << ") = " << std::setw(2) << result.second << ". Example [";
		for ( uint32_t i = 0; i < result.first.size() - 1; ++i ) {
			std::cout << result.first[i] << ", ";
		}
		std::cout << result.first.back() << "]" << std::endl;
	}
}
