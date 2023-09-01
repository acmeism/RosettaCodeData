#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

void padovan(const int32_t& limit, const uint64_t& termCount) {
	std::vector<int32_t> previous_terms = { 1, 1, 1 };

	for ( int32_t N = 2; N <= limit; ++N ) {
		std::vector<int32_t> next_terms = { previous_terms.begin(), previous_terms.begin() + N + 1 };

		while ( next_terms.size() < termCount ) {
			int32_t sum = 0;
			for ( int32_t step_back = 2; step_back <= N + 1; ++step_back ) {
				sum += next_terms[next_terms.size() - step_back];
			}
			next_terms.emplace_back(sum);
		}

		std::cout << N << ": ";
		for ( const int32_t& term : next_terms ) {
			std::cout << std::setw(4) << term;
		}
		std::cout << std::endl;;

		previous_terms = next_terms;
	}
}

int main() {
	const int32_t limit = 8;
	const uint64_t termCount = 15;

	std::cout << "First " << termCount << " terms of the Padovan n-step number sequences:" << std::endl;
	padovan(limit, termCount);
}
