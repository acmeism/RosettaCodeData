#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

constexpr int32_t MAX_ITERATIONS = 151;

double minkowski(const double& x) {
	if ( x < 0 || x > 1 ) {
		return floor(x) + minkowski(x - floor(x));
	}

	int64_t p = (int64_t) x;
	int64_t q = 1;
	int64_t r = p + 1;
	int64_t s = 1;
	double d = 1.0;
	double y = (double) p;

	while ( true ) {
		d /= 2;
		if ( d == 0.0 ) {
			break;
		}

		int64_t m = p + r;
		if ( m < 0 || p < 0 ) {
			break;
		}

		int64_t n = q + s;
		if ( n < 0 ) {
			break;
		}

		if ( x < (double) m / n ) {
			r = m;
			s = n;
		} else {
			y += d;
			p = m;
			q = n;
		}
	}
	return y + d;
}

double minkowski_inverse(double x) {
	if ( x < 0 || x > 1 ) {
		return floor(x) + minkowski_inverse(x - floor(x));
	}

	if ( x == 0 || x == 1 ) {
		return x;
	}

	std::vector<int32_t> continued_fraction(1, 0);
	int32_t current = 0;
	int32_t count = 1;
	int32_t i = 0;

	while ( true ) {
		x *= 2;
		if ( current == 0 ) {
			if ( x < 1 ) {
				count += 1;
			} else {
				 continued_fraction.emplace_back(0);
				 continued_fraction[i] = count;

				 i += 1;
				 count = 1;
				 current = 1;
				 x -= 1;
			}
		} else {
			 if ( x > 1 ) {
				 count += 1;
				 x -= 1;
			 } else {
				 continued_fraction.emplace_back(0);
				 continued_fraction[i] = count;

				 i += 1;
				 count = 1;
				 current = 0;
			 }
		}

		if ( x == floor(x) ) {
			 continued_fraction[i] = count;
			 break;
		}

		if ( i == MAX_ITERATIONS ) {
			 break;
		}
	}

	double reciprocal = 1.0 / continued_fraction[i];
	for ( int32_t j = i - 1; j >= 0; --j ) {
		 reciprocal = continued_fraction[j] + 1.0 / reciprocal;
	}

	return 1.0 / reciprocal;
}

int main() {
	std::cout << std::setw(20) << std::fixed << std::setprecision(16) << minkowski(0.5 * ( 1 + sqrt(5) ))
			  << std::setw(20) << 5.0 / 3.0 << std::endl;
	std::cout << std::setw(20) << minkowski_inverse(-5.0 / 9.0)
			  << std::setw(20) << ( sqrt(13) - 7 ) / 6  << std::endl;
	std::cout << std::setw(20) << minkowski(minkowski_inverse(0.718281828182818))
			  << std::setw(20) << 0.718281828182818 << std::endl;
	std::cout << std::setw(20) << minkowski_inverse(minkowski(0.1213141516271819))
			  << std::setw(20) << 0.1213141516171819 << std::endl;
}
