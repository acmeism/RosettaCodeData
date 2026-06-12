#include <cstdint>
#include <iostream>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]";
}

std::vector<int32_t> differentiate(const std::vector<int32_t>& polynomial) {
	if ( polynomial.size() == 1 ) {
		std::vector<int32_t> result(1, 0);
		return result;
	}

	std::vector<int32_t> derivative(polynomial);
	derivative.erase(derivative.begin());
	for ( uint32_t i = 0; i < derivative.size(); ++i ) {
	   	derivative[i] *= ( i + 1 );
    }
	return derivative;
}

int main() {
	std::cout << "The derivatives of the following polynomials are:" << std::endl << std::endl;
	std::vector<std::vector<int32_t>> polynomials =
        { { 5 }, { 4, -3 }, { -1, 6, 5 }, { -4, 3, -2, 1 }, { 1, 1, 0, -1, -1 } };
	for ( const std::vector<int32_t>& polynomial : polynomials ) {
		print_vector(polynomial); std::cout << " => "; print_vector(differentiate(polynomial)); std::cout << std::endl;
	}
}
