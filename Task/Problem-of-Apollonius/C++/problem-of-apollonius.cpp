#include <cmath>
#include <iostream>
#include <stdexcept>

struct Circle {
	double x;
	double y;
	double radius;

	void display() {
		std::cout << "centre(" << x << ", " << y << ")" << ", radius = " << radius << std::endl;
	}
};

double square(const double& value) {
	return value * value;
}

/**
 * The parameters s1, s2, s3 indicate whether the result circle is
 * internally tangent to the corresponding argument circle (-1), or
 * externally tangent to the corresponding argument circle (+1).
 */
Circle solve_apollonius(const Circle& circle1, const Circle& circle2, const Circle& circle3,
					    const double& s1, const double& s2, const double& s3) {
	if ( abs(s1) != 1 || abs(s2) != 1 || abs(s3) != 1 ) {
		throw std::invalid_argument("Parameters s1, s2, s3 must be +1 or -1");
	}

    const double v11 = 2 * circle2.x - 2 * circle1.x;
    const double v12 = 2 * circle2.y - 2 * circle1.y;
	const double v13 = square(circle1.x) - square(circle2.x) + square(circle1.y) - square(circle2.y)
			         - square(circle1.radius) + square(circle2.radius);
	const double v14 = 2 * s2 * circle2.radius - 2 * s1 * circle1.radius;

	const double v21 = 2 * circle3.x - 2 * circle2.x;
	const double v22 = 2 * circle3.y - 2 * circle2.y;
	const double v23 = square(circle2.x) - square(circle3.x) + square(circle2.y) - square(circle3.y)
					 - square(circle2.radius) + square(circle3.radius);
	const double v24 = 2 * s3 * circle3.radius - 2 * s2 * circle2.radius;

	const double w12 = v12 / v11;
	const double w13 = v13 / v11;
	const double w14 = v14 / v11;

	const double w22 = v22 / v21 - w12;
	const double w23 = v23 / v21 - w13;
	const double w24 = v24 / v21 - w14;

	const double p = -w23 / w22;
	const double q = w24 / w22;
	const double m = -w12 * p - w13;
	const double n = w14 - w12 * q;

	const double a = square(n) + square(q) - 1;
	const double b = 2 * m * n - 2 * n * circle1.x + 2 * p * q - 2 * q * circle1.y + 2 * s1 * circle1.radius;
	const double c = square(circle1.x) + square(m) - 2 * m * circle1.x + square(p)
		+ square(circle1.y) - 2 * p * circle1.y - square(circle1.radius);

	const double discriminant = b * b - 4 * a * c;
	const double root = ( -b - sqrt(discriminant) ) / ( 2 * a );

	const double centre_x = m + n * root;
	const double centre_y = p + q * root;

    return Circle(centre_x, centre_y, root);
}

int main() {
	Circle circle1(0.0, 0.0, 1.0);
	Circle circle2(4.0, 0.0, 1.0);
	Circle circle3(2.0, 4.0, 2.0);

	std::cout << "The three initial circles are:" << std::endl;
	std::cout << "    Circle 1: "; circle1.display();
	std::cout << "    Circle 2: "; circle2.display();
	std::cout << "    Circle 3: "; circle3.display();
	std::cout << std::endl;
	std::cout << "The internal circle is: "; solve_apollonius(circle1, circle2, circle3, -1.0, -1.0, -1.0).display();
	std::cout << "The external circle is: "; solve_apollonius(circle1, circle2, circle3, 1.0, 1.0, 1.0).display();
}
