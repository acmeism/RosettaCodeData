#include <cmath>
#include <iomanip>
#include <iostream>
#include <numbers>
#include <vector>

typedef std::pair<int32_t, int32_t> point;

std::vector<point> babylonian_spiral(int32_t step_count) {
	const double tau = 2 * std::numbers::pi;

	std::vector<int32_t> squares(step_count + 1);
	for ( int32_t i = 0; i < step_count; ++i ) {
		squares[i] = i * i;
	}
	std::vector<point> points { point(0, 0), point (0, 1) };
	int32_t norm = 1;

	for ( int32_t step = 0; step < step_count - 2; ++step ) {
		point previousPoint = points.back();
		const double theta = atan2(previousPoint.second, previousPoint.first);
		std::vector<point> candidates;
		while ( candidates.empty() ) {
			norm += 1;
			for ( int32_t i = 0; i < step_count; ++i ) {
				int32_t a = squares[i];
				if ( a > norm / 2 ) {
					break;
				}
				for ( int32_t j = sqrt(norm) + 1; j >= 0; --j ) {
					int32_t b = squares[j];
					if ( a + b < norm ) {
						break;
					}
					if ( a + b == norm ) {
						std::vector<point> next_points = { point(i, j), point(-i, j), point(i, -j), point(-i, -j),
								                           point(j, i), point(-j, i), point(j, -i), point(-j, -i) };
						candidates.reserve(next_points.size());
						std::move(next_points.begin(), next_points.end(), std::back_inserter(candidates));
					}
				}
			}
		}

		point minimum;
		double minimum_value = tau;
		for ( point candidate : candidates ) {
			double value = fmod(theta - atan2(candidate.second, candidate.first) + tau, tau);
			if ( value < minimum_value ) {
			    minimum_value = value;
			    minimum = candidate;
			}
		}

		points.push_back(minimum);
	}

	for ( uint64_t i = 0; i < points.size() - 1; ++i ) {
		points[i + 1] = point(points[i].first + points[i + 1].first, points[i].second + points[i + 1].second);
	}
	return points;
}

int main() {
	std::vector<point> points = babylonian_spiral(40);
	std::cout << "The first 40 points of the Babylonian spiral are:" << std::endl;
	for ( int32_t i = 0, column = 0; i < 40; ++i ) {
		std::string point_str = "(" + std::to_string(points[i].first) + ", " + std::to_string(points[i].second) + ")";
		std::cout << std::setw(10) << point_str;
		if ( ++column % 10 == 0 ) {
			std::cout << std::endl;
		}
	}
}
