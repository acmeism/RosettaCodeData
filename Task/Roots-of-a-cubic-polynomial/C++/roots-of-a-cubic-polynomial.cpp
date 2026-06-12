#include <cmath>
#include <complex>
#include <cstdint>
#include <iostream>
#include <numbers>
#include <stdexcept>
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

std::vector<double> characteristic_polynomial(const std::vector<std::vector<double>>& matrix) {
	const double a = 1.0;
	const double b = -matrix[0][0] - matrix[1][1] - matrix[2][2]; // = -trace
	const double c =
		  ( matrix[0][0] * matrix[1][1] + matrix[1][1] * matrix[2][2] + matrix[2][2] * matrix[0][0] )
		- ( matrix[1][2] * matrix[2][1] + matrix[2][0] * matrix[0][2] + matrix[0][1] * matrix[1][0] );
	const double d = - matrix[0][0] * matrix[1][1] * matrix[2][2]
					 - matrix[0][1] * matrix[1][2] * matrix[2][0]
					 - matrix[0][2] * matrix[1][0] * matrix[2][1]
					 + matrix[0][0] * matrix[2][1] * matrix[1][2]
					 + matrix[0][1] * matrix[1][0] * matrix[2][2]
					 + matrix[0][2] * matrix[1][1] * matrix[2][0]; // = -determinant
	return { a, b, c, d };
}

std::vector<std::complex<double>> errors(const std::vector<std::complex<double>>& solutions,
										 const std::vector<double>& cubic) {
	std::vector<std::complex<double>> coeffs{ };
	for ( uint32_t i = 0; i < cubic.size(); ++i ) {
		coeffs.emplace_back(std::complex<double>(cubic[i], 0.0));
	}

	std::vector<std::complex<double>> errors{ };
	for ( uint32_t i = 0; i < solutions.size(); ++i ) {
	    errors.emplace_back(( ( ( ( coeffs[0] * solutions[i] + coeffs[1] )
		    * solutions[i] ) + coeffs[2] ) * solutions[i] ) + coeffs[3]);
	}

	return errors;
}

std::vector<std::complex<double>> solve_cubic(const double& a, const double& b, const std::vector<double>& reduced) {
	const double delta = reduced[0], p = reduced[1], q = reduced[2], delta0 = reduced[3], delta1 = reduced[4];
	std::vector<double> real_part_result{ };
	if ( std::abs(delta) < 1e-12 ) { // repeated real roots
		if ( std::abs(p) < 1e-12 ) { // a triple repeated real root
			real_part_result = { 0, 0, 0 };
		} else {                     // a double repeated real root
			const double result12 = -3.0 * q / ( 2.0 * p );
			real_part_result = { 3.0 * q / p, result12, result12 };
		}
	} else if ( delta > 0 ) {        // three distinct real roots
		for ( uint32_t i = 0; i < 3; ++i ) {
			real_part_result.emplace_back( 2.0 * std::sqrt(-p / 3) * std::cos(std::acos(
				std::sqrt(-3 / p) * 3.0 * q / ( 2.0 * p ) ) / 3.0 - 2.0 * std::numbers::pi * i / 3.0 ) );
		}
	} else { // delta < 0            // one real root and two complex conjugate roots
		std::complex<double> g(0.0, 0.0);
		if ( delta0 == 0.0 && delta1 < 0.0 ) {
			g = std::complex<double>(-std::pow(-delta1, 1.0 / 3.0), 0.0);
		} else if ( delta0 < 0.0 && delta1 == 0.0 ) {
			g = std::complex<double>(-std::sqrt(-delta0), 0.0);
		} else {
			const double real_part = std::pow(delta1, 2.0) - 4.0 * std::pow(delta0, 3.0);
			std::complex<double> s = std::sqrt(std::complex<double>(real_part, 0.0));
			std::complex<double> g1 = std::pow(( std::complex<double>(delta1, 0.0) + s ) / 2.0, 1.0 / 3.0);
			std::complex<double> g2 = std::pow(( std::complex<double>(delta1, 0.0) - s ) / 2.0, 1.0 / 3.0);
			g = ( g1 == std::complex<double>(0.0, 0.0) ) ? g2 : g1;
		}

		std::complex<double> z = g * std::complex<double>(-0.5, std::sqrt(3.0) / 2.0);
		std::complex<double> x0 = ( ( std::complex<double>(delta0, 0.0) / g ) + g ) / -3.0;
		std::complex<double> x1 = ( ( std::complex<double>(delta0, 0.0) / z ) + z ) / -3.0;
		std::vector<std::complex<double>> result = { x0, x1, std::conj(x1) };
		for ( uint32_t i = 0; i < 3; ++i ) {
			result[i] -= std::complex<double>(b / ( 3.0 * a ), 0.0);
		}

		return result;
	}

	std::vector<std::complex<double>> result{ };
	for ( uint32_t i = 0; i < 3; ++i ) {
		result.emplace_back(std::complex<double>(real_part_result[i] - b / ( 3.0 * a ), 0.0));
	}

	return result;
}

std::vector<double> reduce(const double& a, const double& b, const double& c, const double& d) {
	const double delta = 18.0 * a * b * c * d - 4.0 * b * b * b * d + b * b * c * c
						 - 4.0 * a * c * c * c - 27.0 * a * a * d * d;
	const double p = ( 3.0 * a * c - b * b ) / ( 3.0 * a * a );
	const double q = ( 2.0 * b * b * b - 9.0 * a * b * c + 27.0 * a * a * d ) / ( 27.0 * a * a * a );
	const double delta0 = b * b - 3.0 * a * c;
	const double delta1 = 2.0 * b * b * b - 9.0 * a * b * c + 27.0 * a * a *d;

	return { delta, p, q, delta0, delta1 };
}

std::vector<std::vector<std::complex<double>>> spectrum(const std::vector<double>& cubic) {
	if ( cubic.size() != 4 || cubic[0] == 0.0 ) {
		throw std::invalid_argument("Not the coefficients of a cubic");
	}

	const double a = cubic[0], b = cubic[1], c = cubic[2], d = cubic[3];
	const std::vector<double> reduced = reduce(a, b, c, d);
	const std::vector<std::complex<double>> solution = solve_cubic(a, b, reduced);
	const std::vector<std::complex<double>> errs = errors(solution, cubic);

	return { solution, errs };
}

int main() {
	const double r = 1.0 / std::sqrt(2.0); // = sin(45°) ≈ 0.7071067811865475
	const std::vector<std::vector<std::vector<double>>> matrices =
		{ { {  1, -1,  0 }, {  0,  1,  1 }, {  0,  0,  1 } },
		  { { -2, -4,  2 }, { -2,  1,  2 }, {  4,  2,  5 } },
		  { {  1, -1,  0 }, {  0,  1, -1 }, {  0,  0,  1 } },
		  { {  2,  0,  0 }, {  0, -1,  0 }, {  0,  0, -1 } },
		  { {  2,  0,  0 }, {  0,  3,  4 }, {  0,  4,  9 } },
		  { {  1,  0,  0 }, {  0,  r, -r }, {  0,  r,  r } } };

	for ( const std::vector<std::vector<double>>& matrix : matrices ) {
		const std::vector<double> polynomial = characteristic_polynomial(matrix);
		const std::vector<std::vector<std::complex<double>>> rainbow = spectrum(polynomial);

		std::cout << "Matrix: "; print_2D_vector(matrix); std::cout << std::endl;
		std::cout << "Characteristic polynomial coefficients "; print_vector(polynomial); std::cout << std::endl;
		std::cout << "Eigenvalues: "; print_vector(rainbow[0]); std::cout << std::endl;
		std::cout << "Errors: "; print_vector(rainbow[1]); std::cout << std::endl;
		std::cout << std::endl;
	}
}
