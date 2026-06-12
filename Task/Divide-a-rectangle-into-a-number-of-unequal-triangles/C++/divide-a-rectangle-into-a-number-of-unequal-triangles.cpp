#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

struct Point {
	float x, y;

	std::string to_string() {
		return "(" + std::to_string(x) + ", " + std::to_string(y) + ")";
	}
};

struct Triangle {
	Point one, two, three;

	std::string to_string() {
		return "[" + one.to_string() + ", " + two.to_string() + ", " + three.to_string() + "]";
	}
};

void divideRectangle(float width, float height, uint32_t triangle_count) {
	if ( triangle_count < 3 ) {
		throw std::invalid_argument("Cannot divide rectangle into less than three triangles.");
	}

	std::cout << "Dividing the rectangle "
		<< "[(0, 0), (" << width << ", 0), (" << width << ", " << height << "), (0, " << height << ")]"
		<< " into " << triangle_count << " triangles: " << std::endl;

	const Point origin(0.0f, 0.0f);
	float side_length = width / ( triangle_count - 1 );
	float first_side_length = side_length; // Length of the edge for the leftmost lower triangle.

	// Ensure that the leftmost lower triangle is not similar to the first triangle. As 'first_side_length < width',
	// this would be the case if 'first_side_length' is such that 'width / height = height / first_side_length'.
	if ( width * first_side_length == height * height ) {
		first_side_length += 1.0;
		side_length = ( width - first_side_length ) / ( triangle_count - 2 );
	}

	std::vector<Triangle> triangles;
	// Add the leftmost lower triangle.
	Triangle triangle(origin, Point(first_side_length, height), Point(0.0f, height));
	triangles.emplace_back(triangle);
	std::cout << triangle.to_string() << std::endl;

	// Add the remaining lower triangles except for the rightmost one to allow for rounding errors.
	float x = first_side_length;
	for ( uint32_t i = 0; i < triangle_count - 3; ++i ) {
		const float nextX = x + side_length;
		triangle = Triangle(origin, Point(nextX, height), Point(x, height));
		triangles.emplace_back(triangle);
		std::cout << triangle.to_string() << std::endl;
		x = nextX;
	}

	// Add the rightmost lower triangle.
	triangle = Triangle(origin, Point(width, height), Point(x, height));
	triangles.emplace_back(triangle);
	std::cout << triangle.to_string() << std::endl;

	// Finally, add the upper triangle.
	triangle = Triangle(origin, Point(width, 0.0f), Point(width, height));
	triangles.emplace_back(triangle);
	std::cout << triangle.to_string() << std::endl;
}

int main() {
	divideRectangle(400, 300, 8);
}
