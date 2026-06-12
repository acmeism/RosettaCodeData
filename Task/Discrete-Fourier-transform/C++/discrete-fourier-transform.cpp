#include <cmath>
#include <cstdint>
#include <complex>
#include <iostream>
#include <numbers>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]";
}

void print_complex_vector(const std::vector<std::complex<double>>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size(); ++i ) {
		const std::complex<double> element = vec[i];
		if ( element.imag() == 0.0 ) {
			std::cout << element.real();
		} else {
			std::cout << "(" << element.real() << ", " << element.imag() << ")";
		}
		if ( i < vec.size() - 1 ) {
			std::cout << ", ";
		}
	}
	std::cout << "]";
}

std::vector<std::complex<double>> clean(const std::vector<std::complex<double>> vec) {
	std::vector<std::complex<double>> result{};

	for ( const std::complex<double> element : vec ) {
		const double real = element.real();
 		const double clean_real = ( std::abs(real - std::round(real)) < 1e-12 ) ? std::round(real) : real;
		const double imag = element.imag();
		const double clean_imag = ( std::abs(imag - std::round(imag)) < 1e-12 ) ? std::round(imag) : imag;
		result.emplace_back(std::complex(clean_real, clean_imag));
	}
	return result;
}

std::vector<std::complex<double>> discrete_fourier_transform(const std::vector<double>& original) {
	std::vector<std::complex<double>> original_complex{};
	for ( const double& value : original ) {
		original_complex.emplace_back(std::complex<double>(value, 0.0));
	}

	const uint32_t size = original_complex.size();
	const double tau = 2.0 * std::numbers::pi;
	std::vector<std::complex<double>> result(size, std::complex<double>(0.0, 0.0));

	for ( uint32_t k = 0; k < size; ++k ) {
		for ( uint32_t n = 0; n < size; ++n ) {
			const double angle = -tau * k * n / size;
			std::complex<double> temp = std::complex<double>(std::cos(angle), std::sin(angle));
			result[k] += temp * original_complex[n];
		}
	}
	return result;
}

std::vector<std::complex<double>> inverse_discrete_fourier_transform(const std::vector<std::complex<double>>& transformed) {
	const uint32_t size = transformed.size();
	const double tau = 2.0 * std::numbers::pi;
	std::vector<std::complex<double>> result(size, std::complex<double>(0.0, 0.0));
	for ( uint32_t n = 0; n < size; ++n ) {
		for ( uint32_t k = 0; k < size; ++k ) {
			const double angle = tau * k * n / size;
			std::complex<double> temp = std::complex<double>(std::cos(angle), std::sin(angle));
			result[n] += transformed[k] * temp;
		}
		result[n] /= size;
	}
	return clean(result);
}

int main() {
	const std::vector<double> original = { 2.0, 3.0, 5.0, 7.0, 11.0 };
	std::cout << "Original sequence: "; print_vector(original); std::cout << std::endl << std::endl;

	const std::vector<std::complex<double>> transformed = discrete_fourier_transform(original);
	std::cout << "After applying the Discrete Fourier Transform:" << std::endl;
	print_vector(transformed); std::cout << std::endl << std::endl;

	std::cout << "After applying the Inverse Discrete Fourier Transform to the above transform:" << std::endl;
	print_complex_vector(inverse_discrete_fourier_transform(transformed)); std::cout << std::endl;
}
