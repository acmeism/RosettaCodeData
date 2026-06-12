#include <algorithm>
#include <cstdint>
#include <iostream>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& list) {
	std::cout << "[";
	for ( uint32_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]";
}

template <typename T>
void print_2D_vector(const std::vector<std::vector<T>>& lists) {
	std::cout << "[";
	for ( uint32_t i = 0; i < lists.size() - 1; ++i ) {
		print_vector(lists[i]); std::cout << ", ";
	}
	print_vector(lists.back()); std::cout << "]";
}

template <typename T>
std::vector<T> intersection(std::vector<T> a, std::vector<T> b) {
    std::vector<T> result = { };
    std::sort(a.begin(), a.end());
    std::sort(b.begin(), b.end());
    std::set_intersection(a.begin(), a.end(), b.begin(), b.end(), back_inserter(result));
    return result;
}

int main() {
	const std::vector<std::vector<std::vector<int32_t>>> tests = {
		{ { 2, 5, 1, 3, 8, 9, 4, 6 }, { 3, 5, 6, 2, 9, 8, 4 }, { 1, 3, 7, 6, 9 } },
		{ { 2, 2, 1, 3, 8, 9, 4, 6 }, { 3, 5, 6, 2, 2, 2, 4 }, { 2, 3, 7, 6, 2 } } };

		for ( std::vector<std::vector<int32_t>> test : tests ) {
			std::vector<int32_t> result = intersection(intersection(test[0], test[1]), test[2]);
			std::cout << "intersection of "; print_2D_vector(test);
			std::cout << " is: "; print_vector(result); std::cout << std::endl;
		}
}
