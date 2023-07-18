#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]" << std::endl;
}

bool contains(const std::vector<int32_t>& list, const int32_t& n) {
	return std::find(list.begin(), list.end(), n) != list.end();
}

bool same_sequence(const std::vector<int32_t>& seq1, const std::vector<int32_t>& seq2, const int32_t& n) {
	for ( uint64_t i = n ; i < seq1.size() ; ++i ) {
		if ( seq1[i] != seq2[i] ) {
			return false;
		}
	}
	return true;
}

std::vector<int32_t> ekg(const int32_t& second_term, const uint64_t& term_count) {
	std::vector<int32_t> result = { 1, second_term };
	int32_t candidate = 2;
	while ( result.size() < term_count ) {
		if ( ! contains(result, candidate) && std::gcd(result.back(), candidate) > 1 ) {
			result.push_back(candidate);
			candidate = 2;
		} else {
			candidate++;
		}
	}
	return result;
}

int main() {
	std::cout << "The first 10 members of EKG[2], EKG[5], EKG[7], EKG[9] and EKG[10] are:" << std::endl;
	for ( int32_t i : { 2, 5, 7, 9, 10 } ) {
		std::cout << "EKG[" << std::setw(2) << i << "] = "; print_vector(ekg(i, 10));
	}
	std::cout << std::endl;

	std::vector<int32_t> ekg5 = ekg(5, 100);
	std::vector<int32_t> ekg7 = ekg(7, 100);
	int32_t i = 1;
	while ( ! ( ekg5[i] == ekg7[i] && same_sequence(ekg5, ekg7, i) ) ) {
		i++;
	}
	// Converting from 0-based to 1-based index
	std::cout << "EKG[5] and EKG[7] converge at index " << i + 1
			  << " with a common value of " << ekg5[i] << "." << std::endl;
}
