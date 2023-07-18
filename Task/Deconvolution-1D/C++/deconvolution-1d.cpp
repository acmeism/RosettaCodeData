#include <algorithm>
#include <cstdint>
#include <iostream>
#include <vector>

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]" << std::endl;
}

std::vector<int32_t> deconvolution(const std::vector<int32_t>& a, const std::vector<int32_t>& b) {
	std::vector<int32_t> result(a.size() - b.size() + 1, 0);
	for ( uint64_t n = 0; n < result.size(); n++ ) {
		result[n] = a[n];
		uint64_t start = std::max((int) (n - b.size() + 1), 0);
		for ( uint64_t i = start; i < n; i++ ) {
			result[n] -= result[i] * b[n - i];
		}
		result[n] /= b[0];
	}
	return result;
}

int main() {
	const std::vector<int32_t> h = { -8, -9, -3, -1, -6, 7 };
	const std::vector<int32_t> f = { -3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1 };
	const std::vector<int32_t> g = { 24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52,
                                     25, -67, -96, 96, 31, 55, 36, 29, -43, -7 };

    std::cout << "h =                   "; print_vector(h);
	std::cout << "deconvolution(g, f) = "; print_vector(deconvolution(g, f));
	std::cout << "f =                   "; print_vector(f);
	std::cout << "deconvolution(g, h) = "; print_vector(deconvolution(g, h));
}
