#include <cmath>
#include <cstdint>
#include <functional>
#include <iomanip>
#include <iostream>
#include <random>
#include <string>
#include <vector>

std::random_device random;
std::mt19937 generator(random());
std::uniform_real_distribution<double> distribution(0.0F, 1.0F);

double modifier(const double& x) {
	return ( x < 0.5 ) ? 2 * ( 0.5 - x ) : 2 * ( x - 0.5 );
}

double modified_random(const std::function<double(double)>& modify) {
	double result = -1.0;

	while ( result < 0.0 ) {
		double random_one = distribution(generator);
		double random_two = distribution(generator);
		if ( random_two < modify(random_one) ) {
			result = random_one;
		}
	}
	return result;
}

int main() {
	const int32_t sample_size = 100'000;
	const int32_t bin_count = 20;
	const double bin_size = 1.0 / bin_count;

	std::vector<int32_t> bins(bin_count, 0);

	for ( int32_t i = 0; i < sample_size; ++i ) {
		double random = modified_random(modifier);
		int32_t bin_number = floor(random / bin_size);
		bins[bin_number]++;
	}

	std::cout << "Modified random distribution with " << sample_size << " samples in range [0, 1):"
              << std::endl << std::endl;
	std::cout << "    Range           		  Number of samples within range" << std::endl;

	const int32_t scale_factor = 125;
	for ( float i = 0.0; i < bin_count; ++i ) {
		std::string histogram = " " + std::string(bins[i] / scale_factor, '#') + " ";
		std::cout << std::fixed << std::setw(4)<< std::setprecision(2) << i / bin_count << " ..< "
				  << std::setw(4) << ( i + 1.0 ) / bin_count << histogram << bins[i] << std::endl;
	}
}
