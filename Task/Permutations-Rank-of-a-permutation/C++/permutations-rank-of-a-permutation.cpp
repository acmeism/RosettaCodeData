#include <cstdint>
#include <iostream>
#include <random>
#include <vector>

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]";
}

uint64_t factorial(const int32_t& n) {
	uint64_t factorial = 1;
	for ( int32_t i = 2; i <= n; ++i ) {
		factorial *= i;
	}
	return factorial;
}

uint64_t rank1(const int32_t& n, std::vector<int32_t>& vec, std::vector<int32_t>& inverse) {
    if ( n < 2 ) {
    	return 0;
    }

    const int32_t last = vec[n - 1];
    std::swap(vec[n - 1], vec[inverse[n - 1]]);
    std::swap(inverse[last], inverse[n - 1]);
    return last + n * rank1(n - 1, vec, inverse);
}

void unrank1(const int64_t& rank, const int32_t& n, std::vector<int32_t>& vec) {
    if ( n < 1 ) {
    	return;
    }

    const int64_t quotient = rank / n;
    const int64_t remainder = rank % n;
    std::swap(vec[remainder], vec[n - 1]);
    unrank1(quotient, n - 1, vec);
}

int64_t rank(const int32_t& n, std::vector<int32_t>& vec) {
	std::vector<int32_t> copy_vec(n, 0);
    std::vector<int32_t> inverse(n, 0);
    for ( int32_t i = 0; i < n; ++i ) {
        copy_vec[i] = vec[i];
        inverse[vec[i]] = i;
    }
    return rank1(n, copy_vec, inverse);
}

void permutation(const int64_t& rank, const int32_t& n, std::vector<int32_t>& vec) {
    std::iota(vec.begin(), vec.end(), 0);
    unrank1(rank, n, vec);
}

int main() {
	int32_t test_size = 3;
	std::vector<int32_t> test_vector(test_size, 0);
	for ( uint64_t count = 0; count < factorial(test_size); ++count ) {
		permutation(count, test_size, test_vector);
		std::cout << count << " -> ";
		print_vector(test_vector);
		std::cout << " -> " << rank(3, test_vector) << std::endl;
	}
	std::cout << std::endl;

	test_size = 12; // test_size can be increased up to a maximum of 20
	test_vector.resize(test_size);

	std::random_device random;
	std::mt19937 generator(random());
	std::uniform_real_distribution<double> distribution(0.0F, 1.0F);

	for ( int32_t count = 0; count < 4; ++count ) {
		const uint64_t rand = distribution(generator) * factorial(test_size);
	    permutation(rand, test_size, test_vector);
	    std::cout << rand << " -> ";
	    print_vector(test_vector);
	    std::cout << " -> " << rank(test_size, test_vector) << std::endl;
	}
}
