#include <iostream>
#include <limits>
#include <string>
#include <vector>

class Point {
public:
	float x;
	float y;
};

class Projection {
public:
	float min;
	float max;

	const bool overlaps(const Projection& other) {
		return ! ( max < other.min || other.max < min );
	}
};

class Vector {
public:
	float x;
	float y;

	const float scalarProduct(const Vector& other) {
		return x * other.x + y * other.y;
	}

	const Vector edgeWith(const Vector& other) {
		return Vector(x - other.x, y - other.y);
	}

	const Vector perpendicular() {
		return Vector(-y, x);
	}

	const std::string to_string() {
		return "(" + std::to_string(x) + ", " + std::to_string(y) + ") ";
	}
};

class Polygon {
public:
	Polygon(const std::vector<Point>& points) {
		computeVertices(points);
		computeAxes();
	}

	const bool overlaps(Polygon& other) {
		std::vector<Vector> allAxes = axes;
		allAxes.insert(allAxes.end(), other.axes.begin(), other.axes.end());

		for ( Vector& axis : allAxes ) {
			Projection projection1 = projectionOnAxis(axis);
			Projection projection2 = other.projectionOnAxis(axis);
			if ( ! projection1.overlaps(projection2) ) {
				return false;
			}
		}

		return true;
	}

	const Projection projectionOnAxis(Vector& axis) {
		float min = std::numeric_limits<float>::infinity();
		float max = -std::numeric_limits<float>::infinity();

		for ( const Vector& vertex : vertices ) {
			double p = axis.scalarProduct(vertex);
			if ( p < min ) {
				min = p;
			}
			if ( p > max ) {
			  max = p;
			}
		}

		return Projection(min, max);
	}

	const std::string to_string() {
		std::string result = "[ ";
		for ( Vector& vertex : vertices ) {
			result += vertex.to_string();
		}

		result += "]";
		return result;
	}

private:
	void computeVertices(const std::vector<Point>& points) {
		for ( const Point& point : points ) {
			vertices.emplace_back(Vector(point.x, point.y));
		}
	}

	void computeAxes() {
		for ( size_t i = 0; i < vertices.size(); i++ ) {
			Vector vertex1 = vertices[i];
			Vector vertex2 = vertices[( i + 1 ) % vertices.size()];
			Vector edge = vertex1.edgeWith(vertex2);
			axes.emplace_back(edge.perpendicular());
		}
	}

	std::vector<Vector> vertices;
	std::vector<Vector> axes;
};

class Rectangle {
public:
	float x;
	float y;
	float width;
	float height;
};

Polygon rectangleToPolygon(const Rectangle& rectangle) {
	return Polygon(std::vector<Point> { Point(rectangle.x, rectangle.y),
		                                Point(rectangle.x + rectangle.width, rectangle.y),
										Point(rectangle.x + rectangle.width, rectangle.y + rectangle.height),
										Point(rectangle.x, rectangle.y + rectangle.height) });
}

int main() {
	Polygon polygon(std::vector<Point> { Point(0.0, 0.0), Point(0.0, 2.0), Point(1.0, 4.0),
										 Point(2.0, 2.0), Point(2.0, 0.0) } );

	Rectangle rectangle1(4.0, 0.0, 2.0, 2.0);

	Rectangle rectangle2(1.0, 0.0, 8.0, 2.0);

	Polygon polygon1 = rectangleToPolygon(rectangle1);
	Polygon polygon2 = rectangleToPolygon(rectangle2);

	std::cout << "polygon: " << polygon.to_string() << std::endl;
	std::cout << "rectangle1: " << polygon1.to_string() << std::endl;
	std::cout << "rectangle2: " << polygon2.to_string() << std::endl;
	std::cout << std::boolalpha << std::endl;
	std::cout << "polygon and polygon2 overlap? " << polygon.overlaps(polygon1) << std::endl;
	std::cout << "polygon and polygon3 overlap? " << polygon.overlaps(polygon2) << std::endl;
}
