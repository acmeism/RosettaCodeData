#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]" << std::endl;
}

bool is_significant(const double p_value, const double significance_level) {
	return p_value > significance_level;
}

// The normalised lower incomplete gamma function.
double gamma_cdf(const double aX, const double aK) {
	double result = 0.0;
	for ( uint32_t m = 0; m <= 99; ++m ) {
		result += pow(aX, m) / tgamma(aK + m + 1);
	}
	result *= pow(aX, aK) * exp(-aX);
	return std::isnan(result) ? 1.0 : result;
}

// The cumulative probability function of the Chi-squared distribution.
double cdf(const double aX, const double aK) {
	if ( aX > 1'000 && aK < 100 ) {
		return 1.0;
	}
	return ( aX > 0.0 && aK > 0.0 ) ? gamma_cdf(aX / 2, aK / 2) : 0.0;
}

void chi_squared_test(const std::vector<int32_t>& observed) {
	double sum = 0.0;
	for ( uint64_t i = 0; i < observed.size(); ++i ) {
		sum += observed[i];
	}
	const double expected = sum / observed.size();

	const int32_t degree_freedom = observed.size() - 1;

	double test_statistic = 0.0;
	for ( uint64_t i = 0; i < observed.size(); ++i ) {
		test_statistic += pow(observed[i] - expected, 2) / expected;
	}

	const double p_value = 1.0 - cdf(test_statistic, degree_freedom);

	std::cout << "\nUniform distribution test" << std::setprecision(6) << std::endl;
	std::cout << "    observed values   : "; print_vector(observed);
	std::cout << "    expected value    : " << expected << std::endl;
	std::cout << "    degrees of freedom: " << degree_freedom << std::endl;
	std::cout << "    test statistic    : " << test_statistic << std::endl;
	std::cout.setf(std::ios::fixed);
	std::cout << "    p-value           : " << p_value << std::endl;
	std::cout.unsetf(std::ios::fixed);
	std::cout << "    is 5% significant?: " << std::boolalpha << is_significant(p_value, 0.05) << std::endl;
}

int main() {
	const std::vector<std::vector<int32_t>> datasets = { { 199809, 200665, 199607, 200270, 199649 },
														 { 522573, 244456, 139979, 71531, 21461 } };
	for ( std::vector<int32_t> dataset : datasets ) {
		chi_squared_test(dataset);
	}
}
