#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

// A double[] is used to represents a Polynomial
// with its coefficients reversed compared to the standard mathematical notation.
// For example, the polynomial 3x^2 + 2x + 1 is represented by the array [1, 2, 3].
std::vector<double> add(const std::vector<double>& one, const std::vector<double>& two) {
	std::vector<double> sum(std::max(one.size(), two.size()), 0.0);
	for ( uint32_t i = 0; i < one.size(); ++i ) {
		sum[i] = one[i];
	}
	for ( uint32_t i = 0; i < two.size(); ++i ) {
		sum[i] += two[i];
	}
	return sum;
}

std::vector<double> multiply(const std::vector<double>& one, const std::vector<double>& two) {
	std::vector<double> product(one.size() + two.size() - 1, 0.0);
	for ( uint32_t i = 0; i < one.size(); ++i ) {
		for ( uint32_t j = 0; j < two.size(); ++j ) {
			product[i + j] += one[i] * two[j];
		}
	}
	return product;
}

std::vector<double> scalar_multiply(std::vector<double> vec, const double& value) {
	std::vector<double> result(vec.size(), 0.0);
	std::transform(vec.begin(), vec.end(), result.begin(), [value](double& d) { return d * value; });
	return result;
}

std::vector<double> scalar_divide(std::vector<double> vec, const double& value) {
	return scalar_multiply(vec, 1.0 / value);
}

double evaluate(const std::vector<double>& vec, const double& value) {
	double result = 0.0;
	for ( int32_t i = vec.size() - 1; i >= 0; --i ) {
		result = result * value + vec[i];
	}
	return result;
}

void display(const std::vector<double> vec) {
	const int32_t degree = vec.size() - 1;
	if ( degree == 0 ) {
		std::cout << std::fixed << std::setprecision(5) << vec[0] << std::endl;
		return;
	}

	for ( int32_t i = degree; i >= 0; i-- ) {
		if ( vec[i] == 0.0 ) {
			continue;
		}
		const std::string sign = ( vec[i] < 0.0 && i == degree ) ?
			"-" : ( vec[i] < 0.0 ) ? " - " : ( i < degree ) ? " + " : "";
		std::cout << sign;
		const double coeff = std::abs(vec[i]);
		if ( coeff > 1.0 ) {
			std::cout << std::fixed << std::setprecision(5) << coeff;
		}
		const std::string term = ( i > 1 ) ? "x^" + std::to_string(i) : ( i == 1 ) ?
			"x" : ( coeff == 1.0 ) ? "1" : "";
		std::cout << term;
	}
	std::cout << std::endl;
}

struct Point {
	double x;
	double y;
};

std::vector<double> lagrange_interpolation(const std::vector<Point>& points) {
	std::vector<std::vector<double>> polys(points.size(), std::vector<double>(points.size(), 0.0));
	for ( uint32_t i = 0; i < points.size(); ++i ) {
		std::vector<double> poly(1, 1.0);
		for ( uint32_t j = 0; j < points.size(); ++j ) {
			if ( i != j ) {
				poly = multiply(poly, { -points[j].x, 1.0 });
			}
		}
		const double value = evaluate(poly, points[i].x);
		polys[i] = scalar_divide(poly, value);
	}

	std::vector<double> sum(1, 0.0);
	for ( uint32_t i = 0; i < points.size(); ++i ) {
		polys[i] = scalar_multiply(polys[i], points[i].y);
		sum = add(sum, polys[i]);
	}
	return sum;
}

int main() {
	const std::vector<Point> points = { Point(1, 1), Point(2, 4), Point(3, 1), Point(4, 5) };

	display(lagrange_interpolation(points));
}
