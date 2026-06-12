#include <cmath>
#include <iomanip>
#include <iostream>

struct Point {
	double x;
	double y;
};

double f(const Point& p) {
	return ( p.x - 1 ) * ( p.x - 1 ) * std::exp(-p.y * p.y) + p.y * ( p.y + 2 ) * std::exp(-2 * p.x * p.x);
}

double dfdx(const Point& p) {
	return 2 * ( p.x - 1 ) * std::exp(-p.y * p.y) - 4 * p.x * p.y * ( p.y + 2 ) * std::exp(-2 * p.x * p.x);
}

double dfdy(const Point& p) {
	return -2 * p.y * ( p.x - 1 ) * ( p.x - 1 ) * std::exp(-p.y * p.y) + 2 * ( p.y + 1 ) * std::exp(-2 * p.x * p.x);
}

Point gradient_descent(Point minimum, double alpha, const double& epsilon) {
	// Calculate initial values
	double minimum_function_value = f(minimum);
	Point gradient(dfdx(minimum), dfdy(minimum));

	// Calculate the step size for the first iteration
	double delta_gradient = std::sqrt(gradient.x * gradient.x + gradient.y * gradient.y);
	double step_size = alpha / delta_gradient;

	while ( delta_gradient > epsilon ) {
		// Calculate the next value for the minimum point
		minimum = Point(minimum.x - step_size * gradient.x, minimum.y - step_size * gradient.y);

		// Calculate next gradient
		gradient = Point(dfdx(minimum), dfdy(minimum));

		// Calculate the step size for the next iteration
		delta_gradient = std::sqrt(gradient.x * gradient.x + gradient.y * gradient.y);
		step_size = alpha / delta_gradient;

		// Calculate the next function value
		const double functionValue = f(minimum);

		// Prepare for the next iteration
		if ( functionValue > minimum_function_value ) {
			alpha /= 2;
		} else {
			minimum_function_value = functionValue;
		}
	}

	return minimum;
}

int main() {
	const double epsilon = 0.000'000'1;
	const double alpha = 0.1;
	const Point initial_point(0.1, -1.0); // Initial estimate for the location of minimum point

	const Point minimum = gradient_descent(initial_point, alpha, epsilon);
	std::cout << "Using the gradient descent method the minimum point occurs at:" << std::endl;
	std::cout << std::fixed << std::setprecision(6) << "x = " << minimum.x << ", " << minimum.y
			  << " for which f(x, y) = " << f(minimum) << std::endl;
}
