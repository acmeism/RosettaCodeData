#include <algorithm>
#include <cmath>
#include <iostream>
#include <random>
#include <stdexcept>
#include <vector>

std::random_device random;
std::mt19937 generator(random());

struct Point {
    double x;
    double y;
};

struct Circle {
    Point centre;
    double radius;
};

double distance(const Point& a, const Point& b) {
    return std::sqrt(( a.x - b.x ) * ( a.x - b.x ) + ( a.y - b.y ) * ( a.y - b.y ));
}

bool encloses(const Point& point, const Circle& circle) {
    return distance(point, circle.centre) <= circle.radius;
}

Circle circle_from_two_points(const Point& a, const Point& b) {
    const Point centre(( a.x + b.x ) / 2.0, ( a.y + b.y ) / 2.0);
    return Circle(centre, distance(a, b) / 2.0);
}

Circle circle_from_three_points(const Point& a, const Point& b, const Point& c) {
	const Point ba(b.x - a.x, b.y - a.y);
	const Point ca(c.x - a.x, c.y - a.y);
	const double bb = ( ba.x * ba.x ) + ( ba.y * ba.y );
	const double cc = ( ca.x * ca.x ) + ( ca.y * ca.y );
	const double dd = ( ba.x * ca.y - ba.y * ca.x) * 2.0;
	const Point centre(( ca.y * bb - ba.y * cc ) / dd + a.x, ( ba.x * cc - ca.x * bb ) / dd + a.y);
	return Circle(centre, distance(centre, a));
}

Circle smallest_enclosing_circle(const std::vector<Point>& points) {
	switch ( points.size() ) {
		case 0: return Circle(Point(0.0, 0.0), 0.0);
		case 1: return Circle(points[0], 0.0);
		case 2: return circle_from_two_points(points[0], points[1]);
		case 3: return circle_from_three_points(points[0], points[1], points[2]);
		default: throw std::runtime_error("Error: too many points on circle boundary");
	}
}

Circle welzl_recursive(std::vector<Point> points, std::vector<Point> boundary) {
    // Base case occurs when all the points have been processed
	// or the smallest enclosing circle boundary is specified by three points
    if ( points.empty() || boundary.size() == 3 ) {
        return smallest_enclosing_circle(boundary);
    }

    // Choose a random point from the given 'points', since 'points' has already been shuffled
    Point point = points.back();
    points.pop_back();

    // Recurse with the chosen point removed
    Circle candidate = welzl_recursive(points, boundary);

    if ( encloses(point, candidate) ) {
        return candidate;
    }

    // Otherwise, 'point' must be on the boundary of the smallest enclosing circle
    boundary.emplace_back(point);

    // Recurse with the chosen point removed from 'points' and added to the 'boundary'
    return welzl_recursive(points, boundary);
}

// Return the smallest enclosing circle using Welzl's algorithm
Circle welzl(const std::vector<Point>& points) {
    std::vector<Point> points_copy = points;
    std::shuffle(points_copy.begin(), points_copy.end(), generator);
    return welzl_recursive(points_copy, std::vector<Point>());
}

int main() {
	const std::vector<std::vector<Point>> tests = {
		{ Point(0.0, 0.0), Point(0.0, 1.0), Point(1.0, 0.0) },
		{ Point(5.0, -2.0), Point(-3.0, -2.0), Point(-2.0, 5.0), Point(1.0, 6.0), Point(0.0, 2.0) },
		{ Point(0.0, 0.0), Point(-2.0, -1.0), Point(3.0, -4.0), Point(2.0, 8.0), Point(3.0, 11.0),
		  Point(-8.0, -2.0), Point(-14.0, -6.0), Point(7.0, 3.0), Point(10.0, 4.0), Point(-1.0, 4.0) }
	};

	for ( const std::vector<Point>& test : tests ) {
		const Circle circle = welzl(test);
		std::cout << "Centre: (" << circle.centre.x << ", " << circle.centre.y
                  << "), Radius: " << circle.radius << std::endl;
	}
}
