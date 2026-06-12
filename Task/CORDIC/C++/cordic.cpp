#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numbers>
#include <vector>

// The following two vectors are pre-computed to avoid using the atan and sqrt functions.

// A table of the arctangents of negative powers of two radians:
// angles[i] = atan(2^-1)
const std::vector<double> angles = {
	0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
	0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
	0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
	0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
	0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
	0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
	0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058
};

// A table of the products of the reciprocal lengths of vectors (1, 2^-2i):
// k_values[i] = product from 0 to i of { 1.0 / sqrt( 1 + 2^-2i )  }
const std::vector<double> k_values = {
	0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
	0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
	0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
	0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
	0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
	0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888
};

const double pi = std::numbers::pi;

double radians(const double& degrees) {
    return degrees * pi / 180.0;
}

void cordic(const double& alpha, const uint32_t& iterations, std::vector<double>& result) {
	const int32_t sign = static_cast<int32_t>(std::floor(alpha / ( 2.0 * pi ))) % 2 == 1 ? 1 : -1;
	if ( alpha < -pi / 2.0 || alpha > pi / 2.0 ) {
		if ( alpha < 0 ) {
			cordic(alpha + pi, iterations, result);
		} else {
			cordic(alpha - pi, iterations, result);
		}
		result[0] = result[0] * sign;
		result[1] = result[1] * sign;
		return;
	}

	uint32_t index = ( iterations < k_values.size() ) ? iterations - 1 : k_values.size() - 1;
	const double k_value = k_values[index];
	double x = 1.0;
	double y = 0.0;
	double theta = 0.0;
	double negative_power_of_2 = 1.0;
	for ( uint32_t i = 0; i < iterations; ++i ) {
		const double angle = angles[i];
		const int32_t sigma = ( theta < alpha ) ? 1 : -1;
		theta += sigma * angle;
		const double temp = x;
		x -= sigma * y * negative_power_of_2;
		y += sigma * temp * negative_power_of_2;
		negative_power_of_2 /= 2.0;
	}
	result[0] = x * k_value;
	result[1] = y * k_value;
}

int main() {
	std::cout << "  x     sin(x)     diff. sine     cos(x)    diff. cosine" << std::endl;
	std::vector<double> result(2, 0.0);
	for ( int32_t degrees = -90; degrees <= +90; degrees += 15 ) {
		const double theta = radians(degrees);
		cordic(theta, 24, result);
		const double cordic_cos = result[0];
		const double cordic_sin = result[1];
		std::cout << std::setw(3) << degrees << "° " << std::showpos << std::fixed << std::setprecision(8)
				  << cordic_sin << " (" << cordic_sin - std::sin(theta) << ") "
				  << cordic_cos << " (" << cordic_cos - std::cos(theta) << ")" << std::endl;
	}

	std::cout << "\nx(rads)  sin(x)      diff. sine      cos(x)     diff. cosine" << std::endl;
	const std::vector<double> angles = { -9.0, 0.0, 1.5, 6.0 };
	for ( uint32_t i = 0; i < angles.size(); ++i ) {
		const double theta = angles[i];
		cordic(theta, 24, result);
		const double cordic_cos = result[0];
		const double cordic_sin = result[1];
		std::cout << std::setw(4) << std::setprecision(1) << theta << "  " << std::showpos << std::fixed
				  << std::setprecision(8) << cordic_sin << "  (" << cordic_sin - std::sin(theta) << ")  "
				  << cordic_cos << "  (" << cordic_cos - std::cos(theta) << ")" << std::endl;
	}
}
