#include <cstdint>
#include <algorithm>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <numbers>

// Return the density of air at 'height' above sea level
double rho(const double& height) {
    return std::exp(-height / 8500.0);
}

// Return the height above sea level at a 'distance' along the line of sight of an observer
// at an 'altitude' viewing at a 'zenith_angle' in degrees from the vertical
double height(const double& altitude, const double& zenith_angle, const double& distance) {
	const double earth_radius = 6371000.0; // metres

	const double aa = earth_radius + altitude;
	const double height = std::sqrt(aa * aa + distance * distance - 2.0 * distance * aa
			                        * std::cos(( 180 - zenith_angle ) * std::numbers::pi / 180.0));
	return height - earth_radius;
}

// Return the integral of air density along the line of sight of an observer
// at an 'altitude' viewing at a 'zenith_angle' in degrees from the vertical
double column_density(const double& altitude, const double& zenith_angle) {
	const double limit_atmosphere = 10'000'000.0; // metres
	const double initial_step_size = 0.001;

	double sum = 0.0;
	double distance = 0.0;
	while ( distance < limit_atmosphere ) {
		// step size increases as the atmosphere becmes less dense
		const double step_size = std::max(distance * initial_step_size, initial_step_size);
		sum += rho(height(altitude, zenith_angle, distance + 0.5 * step_size)) * step_size;
		distance += step_size;
	}
	return sum;
}

// Return the air mass; a measure of the amount of atmosphere between the observer and the object being observed
double air_mass(const double& altitude, const double& zenith_angle) {
    return column_density(altitude, zenith_angle) / column_density(altitude, 0.0);
}

int main() {
	std::cout << "Angle     0 m               13700 m" << std::endl;
	std::cout << "--------------------------------------" << std::endl;
	for ( uint32_t zenith_angle = 0; zenith_angle <= 90; zenith_angle += 5 ) {
		std::cout << std::setw(2) << zenith_angle
				  << std::setw(18) << std::fixed <<std::setprecision(8) << air_mass(0.0, zenith_angle)
				  << std::setw(18) << air_mass(13'700.0, zenith_angle) << std::endl;
	}
}
