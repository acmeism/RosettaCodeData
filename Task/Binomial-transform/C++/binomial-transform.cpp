#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <ranges>
#include <stdexcept>
#include <string>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::ranges::copy(vec, std::ostream_iterator<T>(std::cout, " "));
}

uint64_t factorial(const uint32_t& number) {
    if ( number > 20 ) {
    	throw std::invalid_argument("Too large for 64 bit number: " + std::to_string(number));
    }
    if ( number < 2 ) {
    	return 1;
    }

    uint64_t factorial = 1;
    for ( uint32_t i = 2; i <= number; ++i ) {
    	factorial *= i;
    }
    return factorial;
}

uint64_t binomial(const uint32_t& n, const uint32_t& k) {
   return factorial(n) / factorial(n - k) / factorial(k);
}

std::vector<int64_t> forward(const std::vector<int64_t>& vec) {
	std::vector<int64_t> transform(vec.size(), 0);
    for ( uint32_t n = 0; n < vec.size(); ++n ) {
        for ( uint32_t k = 0; k <= n; ++k ) {
            transform[n] += binomial(n, k) * vec[k];
        }
    }
    return transform;
}

std::vector<int64_t> inverse(const std::vector<int64_t>& vec) {
	std::vector<int64_t> transform(vec.size(), 0);
    for ( uint32_t n = 0; n < vec.size(); ++n ) {
        for ( uint32_t k = 0; k <= n; ++k ) {
            const int32_t sign = ( ( n - k ) & 1 ) ? -1 : 1;
            transform[n] += binomial(n, k) * vec[k] * sign;
        }
    }
    return transform;
}

std::vector<int64_t> self_inverting(const std::vector<int64_t> vec) {
	std::vector<int64_t> transform(vec.size(), 0);
    for ( uint32_t n = 0; n < vec.size(); ++n ) {
        for ( uint32_t k = 0; k <= n; ++k ) {
            const int32_t sign = ( k & 1 ) ? -1 : 1;
            transform[n] += binomial(n, k) * vec[k] * sign;
        }
    }
    return transform;
}

int main() {
	const std::vector<std::vector<int64_t>> sequences = {
	    { 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845 },
	    { 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0 },
	    { 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181 },
	    { 1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37 }
	};

	const std::vector<std::string> names = {
	    "Catalan number sequence:",
		"Prime flip-flop sequence:",
		"Fibonacci number sequence:",
		"Padovan number sequence:"
	};

	for ( uint32_t i = 0; i < sequences.size(); ++i ) {
		std::cout << names[i] << std::endl;
		print_vector(sequences[i]);
		std::cout << "\n" << "Forward binomial transform:" << std::endl;
		print_vector(forward(sequences[i]));
		std::cout << "\n" << "Inverse binomial transform:" << std::endl;
		print_vector(inverse(sequences[i]));
		std::cout << "\n" << "Round trip:" << std::endl;
		print_vector(inverse(forward(sequences[i])));
		std::cout << "\n" << "Self-inverting:" << std::endl;
		print_vector(self_inverting(sequences[i]));
		std::cout << "\n" << "Round trip self-inverting:" << std::endl;
		print_vector(self_inverting(self_inverting(sequences[i])));
		std::cout << std::endl << std::endl;
	}
}
