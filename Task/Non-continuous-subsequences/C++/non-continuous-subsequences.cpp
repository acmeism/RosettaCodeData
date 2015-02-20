/*
	Not best code, wrote it really quick.  Will add updated code using more C++11 features soon!
*/

#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>

int main() {
	std::vector<int> sequence = { 0, 1, 2, 3, 4 };
	std::vector<int> work = { 0 };
	std::vector<std::vector<int>> results;
	while (work != sequence) {
		bool zeroed = false;
		size_t index_zero_started = 0;
		for (size_t i = 0; i < work.size(); ++i) {
			if (work[i] >= sequence.size()) {
				if (i == 0) {
					work[i] = 0;
					work.push_back(0);
					index_zero_started = i;
				} else {
					++work[i - 1];
					for (size_t j = i; j < work.size(); ++j) {
						work[j] = 0;
					}
					index_zero_started = i - 1;
				}
				zeroed = true;
				break;
			}
		}
		if (zeroed) {
			for (size_t i = index_zero_started + 1; i < work.size(); ++i) {
				work[i] = work[i - 1] + 1;
			}
		} else {
			std::vector<int> temp_differences;
			std::adjacent_difference(std::begin(work), std::end(work), std::back_inserter(temp_differences));
			if (std::find_if(std::begin(temp_differences) + 1, std::end(temp_differences),
				[](const int& n) { return n > 1; }) != std::end(temp_differences)) {
				results.push_back(work);
			}
			++work.back();
		}
	}
	std::cout << "Non-continuous subsequences of ";
	std::copy(std::begin(sequence), std::end(sequence), std::ostream_iterator<int>(std::cout, " "));
	std::cout << std::endl;
	for (auto& e: results) {
		std::cout << "- ";
		std::copy(std::begin(e), std::end(e), std::ostream_iterator<int>(std::cout, " "));
		std::cout << std::endl;
	}
	return 0;
}
