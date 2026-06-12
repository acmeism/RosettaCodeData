#include <algorithm>
#include <cstdint>
#include <iostream>
#include <set>
#include <string>
#include <vector>

class Point {
public:
	Point(const int32_t& x, const int32_t& y) : x(x), y(y) {}

	bool operator<(const Point& other) const {
		return x < other.x || ( x == other.x && y < other.y );
	}

	bool operator==(const Point& other) const {
		return x == other.x && y == other.y;
	}

	Point rotate90() const { return Point(y, -x); }
	Point rotate180() const { return Point(-x, -y); }
	Point rotate270() const { return Point(-y, x); }
	Point reflect_in_y_axis() const { return Point(-x, y); }

	std::vector<Point> contiguous_points() const {
		return { Point(x - 1, y), Point(x + 1, y), Point(x, y - 1), Point(x, y + 1) };
	}

	std::string to_string() const {
		return "(" + std::to_string(x) + ", " + std::to_string(y) + ")";
	}

	int32_t x, y;
};

class Polyomino {
public:
	Polyomino(const std::vector<Point>& points) : points(points) {}

	Polyomino() {}

	bool operator<(const Polyomino& other) const {
		return points < other.points;
	}

	std::vector<Polyomino> rotations_and_reflections() const {
		std::vector<Polyomino> result(8, Polyomino());
		for ( uint32_t i = 0; i < points.size(); ++i ) {
			result[0].points.emplace_back(points[i]);
			result[1].points.emplace_back(points[i].rotate90());
			result[2].points.emplace_back(points[i].rotate180());
			result[3].points.emplace_back(points[i].rotate270());
			result[4].points.emplace_back(points[i].reflect_in_y_axis());
			result[5].points.emplace_back(points[i].reflect_in_y_axis().rotate90());
			result[6].points.emplace_back(points[i].reflect_in_y_axis().rotate180());
			result[7].points.emplace_back(points[i].reflect_in_y_axis().rotate270());
		}
		return result;
	}

	std::vector<int32_t> minima() const {
		int32_t minX = INT32_MAX;
		int32_t minY = INT32_MAX;
		for ( const Point& point : points ) {
			if ( point.x < minX ) { minX = point.x; }
			if ( point.y < minY ) { minY = point.y; }
		}
		return { minX, minY };
	}

	Polyomino translate_to_origin() const {
		std::vector<int32_t> minimums = minima();
		Polyomino translated{ };
		for ( Point point : points ) {
			translated.points.emplace_back(Point(point.x - minimums[0], point.y - minimums[1]));
		}
		std::sort(translated.points.begin(), translated.points.end());
		return translated;
	}

	Polyomino canonical() const {
		std::vector<Polyomino> polyominoes = rotations_and_reflections();
		Polyomino min_polyomino = polyominoes[0].translate_to_origin();
		for ( uint32_t i = 1; i < polyominoes.size(); ++i ) {
			Polyomino polyomino_i = polyominoes[i].translate_to_origin();
			if ( polyomino_i.points < min_polyomino.points ) {
				min_polyomino = polyomino_i;
			}
		}
		return min_polyomino;
	}

	std::vector<Point> new_points() const {
	    std::set<Point> result{ };
	    for ( const Point& point : points ) {
	        for ( const Point pt : point.contiguous_points() ) {
				if ( std::find(points.begin(), points.end(), pt) == points.end() ) {
					result.insert(pt);
				}
	        }
	    }
		std::vector<Point> new_points(result.begin(), result.end());
	    return new_points;
	}

	std::vector<Polyomino> new_polyominoes() const {
		std::vector<Polyomino> polyominoes{ };
		for ( const Point& point : new_points() ) {
			std::vector<Point> points_copy = points;
			points_copy.emplace_back(point);
			polyominoes.emplace_back(Polyomino(points_copy).canonical());
		}
		return polyominoes;
	}

	std::string to_string() const {
		std::string result = "[";
		for ( uint32_t i = 0; i < points.size(); ++i ) {
			result += points[i].to_string();
			if ( i < points.size() - 1 ) { result += ", "; }
		}
		result += "]";
		return result;
	}

	std::vector<Point> points;
};

const std::vector<Polyomino> monominoes{ Polyomino(std::vector<Point>{ Point(0, 0) }) };

std::vector<Polyomino> polyominoes_of_rank(const uint32_t& number) {
    if ( number == 0 ) {
    	return std::vector<Polyomino>{ Polyomino() };
    }
    if ( number == 1 ) {
    	return monominoes;
    }

    std::set<Polyomino> polyominoes{ };
    for ( const Polyomino& polyomino : polyominoes_of_rank(number - 1) ) {
    	for ( const Polyomino& poly : polyomino.new_polyominoes() ) {
    		polyominoes.insert(poly);
    	}
    }
    std::vector<Polyomino> result(polyominoes.begin(), polyominoes.end());
    return result;
}

int main() {
	const uint32_t n = 5;
	std::cout << "All free polyominoes of rank " << n << std::endl;
	for ( const Polyomino& polyomino : polyominoes_of_rank(n) ) {
		std::cout << polyomino.to_string() << std::endl;
	}

	const uint32_t k = 10;
	std::cout << "\nNumber of free polyominoes of ranks 1 to " << k << ":" << std::endl;
	for ( uint32_t i = 1; i <= k; ++i ) {
		std::cout << polyominoes_of_rank(i).size() << " ";
	}
	std::cout << std::endl;
}
