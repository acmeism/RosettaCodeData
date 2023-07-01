#include <iostream>
#include <vector>
#include <algorithm>
#include <map>
#include <queue>
#include <numeric>
#include <iomanip>

std::vector<int32_t> flip_stack(std::vector<int32_t>& stack, const int32_t index) {
	reverse(stack.begin(), stack.begin() + index);
	return stack;
}

std::pair<std::vector<int32_t>, int32_t> pancake(const int32_t number) {
	std::vector<int32_t> initial_stack(number);
	std::iota(initial_stack.begin(), initial_stack.end(), 1);
	std::map<std::vector<int32_t>, int32_t> stack_flips = { std::make_pair(initial_stack, 1) };
	std::queue<std::vector<int32_t>> queue;
	queue.push(initial_stack);

	while ( ! queue.empty() ) {
		std::vector<int32_t> stack = queue.front();
		queue.pop();

		const int32_t flips = stack_flips[stack] + 1;
		for ( int i = 2; i <= number; ++i ) {
			std::vector<int32_t> flipped = flip_stack(stack, i);
			if ( stack_flips.find(flipped) == stack_flips.end() ) {
				stack_flips[flipped] = flips;
				queue.push(flipped);
			}
		}
    }

	auto ptr = std::max_element(
		stack_flips.begin(), stack_flips.end(),
		[] ( const auto & pair1, const auto & pair2 ) {
	    	return pair1.second < pair2.second;
		}
	);

	return std::make_pair(ptr->first, ptr->second);
}

int main() {
	for ( int32_t n = 1; n <= 9; ++n ) {
		std::pair<std::vector<int32_t>, int32_t> result = pancake(n);
		std::cout << "pancake(" << n << ") = " << std::setw(2) << result.second << ". Example [";
		for ( uint64_t i = 0; i < result.first.size() - 1; ++i ) {
			std::cout << result.first[i] << ", ";
		}
		std::cout << result.first.back() << "]" << std::endl;
	}
}
