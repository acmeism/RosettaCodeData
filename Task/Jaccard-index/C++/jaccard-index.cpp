#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <unordered_set>
#include <vector>

template <typename T>
std::string vector_to_string(const std::vector<T>& vec) {
	std::string result = "[";
	for ( uint32_t i = 0; i < vec.size(); ++i ) {
		result += std::to_string(vec[i]);
		if ( i < vec.size() - 1 ) {
			result += ", ";
		}
	}
	return result + "]";
}

double jaccard_index(const std::vector<int32_t>& a, const std::vector<int32_t>& b) {
	std::unordered_set<int32_t> copy_a(a.begin(), a.end());
	const uint32_t intersection_count = std::count_if(b.begin(), b.end(),
		[&](const int32_t& element) { return copy_a.find(element) != copy_a.end(); });

	std::unordered_set<int32_t> union_set = copy_a;
	union_set.insert(b.begin(), b.end());
	const uint32_t union_count = union_set.size();
	return ( union_count == 0 ) ? 1.0 : ( intersection_count == 0 ) ?
		0.0 : (double) intersection_count / union_count;
}

int main() {
	std::vector<std::vector<int32_t>> tests = {
		{ },
		{ 1, 2, 3, 4, 5 },
		{ 1, 3, 5, 7, 9 },
		{ 2, 4, 6, 8, 10 },
		{ 2, 3, 5, 7 },
		{ 8 }
	};

	std::cout << "     Set A              Set B         J(A, B)" << std::endl;
	std::cout << "---------------------------------------------" << std::endl;
	for ( const std::vector<int32_t>& a : tests ) {
		for ( const std::vector<int32_t>& b : tests ) {
			std::cout << std::left << std::setw(19) << vector_to_string(a) << std::setw(19) << vector_to_string(b)
				      << std::fixed << std::setprecision(5) <<jaccard_index(a, b) << std::endl;
		}
	}
}
