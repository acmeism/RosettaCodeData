#include <cstdint>
#include <iostream>
#include <vector>

std::string to_string(const std::vector<double>& list) {
	std::string result = "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		result += std::to_string(list[i]) + ", ";
	}
	result += std::to_string(list.back()) + "]";
	return result;
}

// Subprogram (1)
std::vector<double> monomial_to_bernstein_degree2(const std::vector<double>& monomial) {
	return std::vector<double>{ monomial[0],
								monomial[0] + ( monomial[1] / 2.0 ),
								monomial[0] + monomial[1] + monomial[2] };
}

// Subprogram (2)
double evaluate_bernstein_degree2(const std::vector<double>& bernstein, const double& t) {
	// de Casteljau’s algorithm
	const double s = 1 - t;
	const double b01 = ( s * bernstein[0] ) + ( t * bernstein[1] );
	const double b12 = ( s * bernstein[1] ) + ( t * bernstein[2] );
	return ( s * b01 ) + ( t * b12 );
}

// Subprogram (3)
std::vector<double> monomial_to_bernstein_degree3(const std::vector<double>& monomial) {
	return  std::vector<double>{ monomial[0],
							     monomial[0] + ( monomial[1] / 3.0 ),
								 monomial[0] + ( 2.0 * monomial[1] / 3.0 ) + ( monomial[2] / 3.0 ),
								 monomial[0] + monomial[1] + monomial[2] + monomial[3] };
}

// Subprogram (4)
double evaluate_bernstein_degree3(const std::vector<double>& bernstein, const double& t) {
	// de Casteljau’s algorithm
	const double s = 1 - t;
	const double b01 = ( s * bernstein[0] ) + ( t * bernstein[1] );
	const double b12 = ( s * bernstein[1] ) + ( t * bernstein[2] );
	const double b23 = ( s * bernstein[2] ) + ( t * bernstein[3] );
	const double b012 = ( s * b01 ) + ( t * b12 );
	const double b123 = ( s * b12 ) + ( t * b23 );
	return ( s * b012 ) + ( t * b123 );
}

// Subprogram (5)
std::vector<double> bernstein_degree2_to_degree3(const std::vector<double>& bernstein) {
	return std::vector<double>{ bernstein[0],
								( bernstein[0] / 3.0 ) + ( 2.0 * bernstein[1] / 3.0 ),
								( 2.0 * bernstein[1] / 3.0 ) + ( bernstein[2] / 3.0 ),
								bernstein[2] };
}

double evaluate_monomial_degree2(const std::vector<double>& monomial, const double& t) {
	// Horner’s rule
	return monomial[0] + ( t * ( monomial[1] + ( t * monomial[2] ) ) );
}

double evaluate_monomial_degree3(const std::vector<double>& monomial, const double& t) {
	// Horner’s rule
	return monomial[0] + ( t * ( monomial[1] + ( t * ( monomial[2] + ( t * monomial[3] ) ) ) ) );
}

int main() {
	/**
	 * For the following polynomials,
     * use Subprogram (1) to find coefficients in the degree-2 Bernstein basis:
	 *
	 *  p(x) = 1
	 *  q(x) = 1 + 2x + 3x²
	 */
	std::vector<double> pMonomial2 = { 1.0, 0.0, 0.0 };
	std::vector<double> qMonomial2 = { 1.0, 2.0, 3.0 };
	std::vector<double> pBernstein2 = monomial_to_bernstein_degree2(pMonomial2);
	std::vector<double> qBernstein2 = monomial_to_bernstein_degree2(qMonomial2);
	std::cout << "Subprogram (1) examples:" << std::endl;
	std::cout << "    monomial " + to_string(pMonomial2) + " --> bernstein "
        + to_string(pBernstein2) << std::endl;
	std::cout << "    monomial " + to_string(qMonomial2) + " --> bernstein "
        + to_string(qBernstein2) << std::endl;

	/**
	 * Use Subprogram (2) to evaluate p(x) and q(x) at x = 0.25, 7.50. Display the results.
	 * Optionally also display results from evaluating in the original monomial basis.
	 */
	std::cout << "Subprogram (2) examples:" << std::endl;
	for ( const double& x : { 0.25, 7.50 } ) {
		std::cout << "    p(" << x << ") = " << evaluate_bernstein_degree2(pBernstein2, x)
			      << " ( mono: " << evaluate_monomial_degree2(pMonomial2, x) << " )" << std::endl;
	}
	for ( const double& x : { 0.25, 7.50 } ) {
		std::cout << "    q(" << x << ") = " << evaluate_bernstein_degree2(qBernstein2, x)
				  << " ( mono: " << evaluate_monomial_degree2(qMonomial2, x) << " )" << std::endl;
	}

	/**
	 * For the following polynomials,
     * use Subprogram (3) to find coefficients in the degree-3 Bernstein basis:
	 *
	 *  p(x) = 1
	 *  q(x) = 1 + 2x + 3x²
	 *  r(x) = 1 + 2x + 3x² + 4x³
	 *
	 * Display the results.
	 */
	std::vector<double> pMonomial3 = { 1.0, 0.0, 0.0, 0.0 };
	std::vector<double> qMonomial3 = { 1.0, 2.0, 3.0, 0.0 };
	std::vector<double> rMonomial3 = { 1.0, 2.0, 3.0, 4.0 };
	std::vector<double> pBernstein3 = monomial_to_bernstein_degree3(pMonomial3);
	std::vector<double> qBernstein3 = monomial_to_bernstein_degree3(qMonomial3);
	std::vector<double> rBernstein3 = monomial_to_bernstein_degree3(rMonomial3);
	std::cout << "Subprogram (3) examples:" << std::endl;
	std::cout << "    monomial " + to_string(pMonomial3) + " --> bernstein "
        + to_string(pBernstein3) << std::endl;
	std::cout << "    monomial " + to_string(qMonomial3) + " --> bernstein "
        + to_string(qBernstein3) << std::endl;
	std::cout << "    monomial " + to_string(rMonomial3) + " --> bernstein "
        + to_string(rBernstein3) << std::endl;

	/**
	 * Use Subprogram (4) to evaluate p(x), q(x), and r(x) at x = 0.25, 7.50.  Display the results.
	 * Optionally also display results from evaluating in the original monomial basis.
	 */
	std::cout << "Subprogram (4) examples:" << std::endl;
	for ( const double& x : { 0.25, 7.50 } ) {
		std::cout << "    p(" << x << ") = " << evaluate_bernstein_degree3(pBernstein3, x)
			      << " ( mono: " << evaluate_monomial_degree3(pMonomial3, x) << " )" << std::endl;
	}
	for ( const double& x : { 0.25, 7.50 } ) {
		std::cout << "    q(" << x << ") = " << evaluate_bernstein_degree3(qBernstein3, x)
				  << " ( mono: " << evaluate_monomial_degree3(qMonomial3, x) << " )" << std::endl;
	}
	for ( const double& x : { 0.25, 7.50 } ) {
		std::cout << "    r(" << x << ") = " << evaluate_bernstein_degree3(rBernstein3, x)
				  << " ( mono: " << evaluate_monomial_degree3(rMonomial3, x) << " )" << std::endl;
	}

	/**
	 * For the following polynomials, using the result of Subprogram (1) applied to the polynomial,
	 * use Subprogram (5) to get coefficients for the degree-3 Bernstein basis:
	 *
	 *  p(x) = 1
	 *  q(x) = 1 + 2x + 3x²
	 *
	 * Display the results.
	 */
	std::cout << "Subprogram (5) examples:" << std::endl;
	std::vector<double> pBernstein3a = bernstein_degree2_to_degree3(pBernstein2);
	std::vector<double> qBernstein3a = bernstein_degree2_to_degree3(qBernstein2);
	std::cout << "    bernstein " + to_string(pBernstein2) + " --> bernstein "
        + to_string(pBernstein3a) << std::endl;
	std::cout << "    bernstein " + to_string(qBernstein2) + " --> bernstein "
        + to_string(qBernstein3a) << std::endl;
}
