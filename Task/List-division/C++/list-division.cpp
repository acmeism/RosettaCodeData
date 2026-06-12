#include <cstdint>
#include <iostream>
#include <vector>

template <typename T>
struct Tuple {
	std::vector<T> vec;
	uint32_t part_count;
};

template <typename T>
void divide_list(Tuple<T> tuple) {
	std::vector<std::vector<T>> result;
	const uint32_t quotient = tuple.vec.size() / tuple.part_count;
	const uint32_t remainder = tuple.vec.size() % tuple.part_count;

	uint32_t start = 0;
	for ( uint32_t part = 0; part < tuple.part_count; ++part ) {
		const uint32_t size = ( part < remainder ) ? quotient + 1 : quotient;
		if ( size > 0 ) {
			std::vector<int32_t> sub_vec(tuple.vec.begin() + start, tuple.vec.begin() + start + size);
			result.emplace_back(sub_vec);
			start += size;
		}
	}

	std::cout << "[";
	for ( uint64_t i = 0; i < result.size(); ++i ) {
		std::cout << "[";
		for ( uint64_t j = 0; j < result[i].size(); ++j ) {
			std::cout << result[i][j];
			if ( j < result[i].size() - 1 ) {
				std::cout << ", ";
			}
		}
		std::cout << "]";
		if ( i < result.size() - 1 ) {
			std::cout << ", ";
		}
	}
	std::cout << "]" << std::endl;
}

int main() {
	std::vector<Tuple<int32_t>> tests = {
		Tuple(std::vector<int32_t> { 94, 94, 13, 77, 35, 10, 51, 27, 60 }, 6),
		Tuple(std::vector<int32_t> { 19, 46, 43, 17, 94 }, 1),
		Tuple(std::vector<int32_t> { 93, 88, 40, 88, 30, 68, 84, 25 }, 3),
		Tuple(std::vector<int32_t> { 88, 94, 10, 27, 54, 14 }, 3),
		Tuple(std::vector<int32_t> { 31, 19, 63, 57, 57, 74, 50, 14, 38 }, 4),
		Tuple(std::vector<int32_t> { 72, 57, 89, 55, 36, 84, 10, 95, 99, 35 }, 7),
		// The following lists are divided as far as possible, without returning empty lists
		Tuple(std::vector<int32_t> { 23, 49, 57 }, 10),
		Tuple(std::vector<int32_t> { 1 }, 2),
		Tuple(std::vector<int32_t> { }, 2)
	};

	for ( const Tuple<int32_t>& test : tests ) {
		divide_list(test);
	}
}
