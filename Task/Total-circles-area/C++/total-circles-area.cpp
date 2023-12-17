#include <algorithm>
#include <cfloat>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

struct Pair_X {
	double x1;
	double x2;

	bool operator <(const Pair_X& pair_x) const {
		return x1 < pair_x.x1;
	}
};

struct Circle {
	double centre_x;
	double centre_y;
	double radius;
};

const std::vector<Circle> circles = {
	Circle( 1.6417233788,  1.6121789534, 0.0848270516),
	Circle(-1.4944608174,  1.2077959613, 1.1039549836),
	Circle( 0.6110294452, -0.6907087527, 0.9089162485),
	Circle( 0.3844862411,  0.2923344616, 0.2375743054),
	Circle(-0.2495892950, -0.3832854473, 1.0845181219),
	Circle( 1.7813504266,  1.6178237031, 0.8162655711),
	Circle(-0.1985249206, -0.8343333301, 0.0538864941),
	Circle(-1.7011985145, -0.1263820964, 0.4776976918),
	Circle(-0.4319462812,  1.4104420482, 0.7886291537),
	Circle( 0.2178372997, -0.9499557344, 0.0357871187),
	Circle(-0.6294854565, -1.3078893852, 0.7653357688),
	Circle( 1.7952608455,  0.6281269104, 0.2727652452),
	Circle( 1.4168575317,  1.0683357171, 1.1016025378),
	Circle( 1.4637371396,  0.9463877418, 1.1846214562),
	Circle(-0.5263668798,  1.7315156631, 1.4428514068),
	Circle(-1.2197352481,  0.9144146579, 1.0727263474),
	Circle(-0.1389358881,  0.1092805780, 0.7350208828),
	Circle( 1.5293954595,  0.0030278255, 1.2472867347),
	Circle(-0.5258728625,  1.3782633069, 1.3495508831),
	Circle(-0.1403562064,  0.2437382535, 1.3804956588),
	Circle( 0.8055826339, -0.0482092025, 0.3327165165),
	Circle(-0.6311979224,  0.7184578971, 0.2491045282),
	Circle( 1.4685857879, -0.8347049536, 1.3670667538),
	Circle(-0.6855727502,  1.6465021616, 1.0593087096),
	Circle( 0.0152957411,  0.0638919221, 0.9771215985)
};

Pair_X horizontal_section(const Circle& circle, const double& y) {
	const double value = circle.radius * circle.radius - ( y - circle.centre_y ) * ( y - circle.centre_y );
	double delta_x = std::sqrt(value);
	return Pair_X(circle.centre_x - delta_x, circle.centre_x + delta_x);
}

double area_scan(const double& precision) {
	std::vector<double> y_values;
	for ( const Circle& circle : circles ) {
		y_values.emplace_back(circle.centre_y + circle.radius);
	}
	for ( const Circle& circle : circles ) {
		y_values.emplace_back(circle.centre_y - circle.radius);
	}

	const double min = *min_element(y_values.begin(), y_values.end());
	const double max = *max_element(y_values.begin(), y_values.end());
	const int64_t min_y = std::floor(min / precision);
	const int64_t max_y = std::ceil(max / precision);

    double total_area = 0.0;
    for ( int64_t i = min_y; i <= max_y; ++i ) {
    	double y = i * precision;
    	double right = -DBL_MAX;

    	std::vector<Pair_X> pairs_x;
    	for ( const Circle& circle : circles ) {
    		if ( std::fabs(y - circle.centre_y) < circle.radius ) {
    			pairs_x.emplace_back(horizontal_section(circle, y));
    		}
    	}
    	std::sort(pairs_x.begin(), pairs_x.end());

    	for ( const Pair_X& pair_x : pairs_x ) {
			if ( pair_x.x2 > right ) {
				total_area += pair_x.x2 - std::max(pair_x.x1, right);
				right = pair_x.x2;
			}
		}
    }
    return total_area * precision;
}

int main() {
	const double precision = 0.00001;
	std::cout << "Approximate area = " << std::setprecision(9) << area_scan(precision);
}
