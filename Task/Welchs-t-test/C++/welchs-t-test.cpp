#include <cmath>
#include <cstdint>
#include <functional>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <vector>

double mean(const std::vector<double>& vec) {
	double sum = 0.0;
	for ( const double& element : vec ) {
		sum += element;
	}
	return sum / vec.size();
}

double sample_variance(const std::vector<double>& vec) {
	const uint32_t size = vec.size();
    if ( size < 2 ) {
    	throw std::invalid_argument("Vector must have at least 2 elements");
    }

    const double average = mean(vec);
    double sum_squares = 0.0;
    for ( const double& element : vec ) {
    	sum_squares += ( element - average ) * ( element - average );
    }
    return sum_squares / ( size - 1 );
}

double degrees_of_freedom(const std::vector<double>& one, const std::vector<double>& two) {
    const double sv1 = sample_variance(one);
    const double sv2 = sample_variance(two);
    const uint32_t n1 = one.size();
    const uint32_t n2 = two.size();
    const double numer = ( sv1 / n1 + sv2 / n2 ) * ( sv1 / n1 + sv2 / n2 );
    const double denom = ( sv1 * sv1 ) / ( n1 * n1 * ( n1 - 1 ) ) + ( sv2 * sv2 ) / ( n2 * n2 * ( n2 - 1 ) );
    return numer / denom;
}

double welch(const std::vector<double>& one, const std::vector<double>& two) {
    const double temp = sample_variance(one) / one.size() + sample_variance(two) / two.size();
    return ( mean(one) - mean(two) ) / std::sqrt(temp);
}

double simpson(const double& a, const double& b, const uint32_t& n, const std::function<double(double)>& func) {
    const double h = ( b - a ) / n;
    double sum = 0.0;
    for ( uint32_t i = 0; i < n; ++i ) {
    	const double x = a + i * h;
    	sum += ( func(x) + 4.0 * func(x + h / 2.0) + func(x + h) ) / 6.0;
    }
    return sum * h;
}

double p2_tail(const std::vector<double>& one, const std::vector<double>& two) {
    const double dof = degrees_of_freedom(one, two);
    const double welchs = welch(one, two);
    const double gamm = std::exp(std::lgamma(dof / 2.0) + std::lgamma(0.5) - std::lgamma(dof / 2.0 + 0.5));
    const double b = dof / ( welchs * welchs + dof );
    const std::function<double(double)> func =
    	[&](const double& r) { return std::pow(r, dof / 2.0 - 1.0) / std::sqrt(1.0 - r); };
    return simpson(0.0, b, 10'000, func) / gamm;
}

int main() {
	const std::vector<double> vec1 =
		{ 27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4 };
	const std::vector<double> vec2 =
		{ 27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4 };
	const std::vector<double> vec3 = { 17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8 };
	const std::vector<double> vec4 = { 21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8 };
	const std::vector<double> vec5 = { 19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0 };
	const std::vector<double> vec6 = { 28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2 };
	const std::vector<double> vec7 = { 30.02, 29.99, 30.11, 29.97, 30.01, 29.99 };
	const std::vector<double> vec8 = { 29.89, 29.93, 29.72, 29.98, 30.02, 29.98 };

	const std::vector<double> vecX = { 3.0, 4.0, 1.0, 2.1 };
	const std::vector<double> vecY = { 490.2, 340.0, 433.9 };

	std::cout << std::fixed << std::setprecision(6);
	std::cout << p2_tail(vec1, vec2) << std::endl;
	std::cout << p2_tail(vec3, vec4) << std::endl;
	std::cout << p2_tail(vec5, vec6) << std::endl;
	std::cout << p2_tail(vec7, vec8) << std::endl;
	std::cout << p2_tail(vecX, vecY) << std::endl;
}
