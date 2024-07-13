#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <vector>

// A point of the current Catmull-Clark surface.
class Point {
public:
	Point() : x(0.0), y(0.0), z(0.0) { }
	Point(const double& aX, const double& aY, const double& aZ) : x(aX), y(aY), z(aZ) { }

	Point add(const Point& other) const {
		return Point(x + other.x, y + other.y, z + other.z);
	}

	Point multiply(const double& factor) const {
		return Point(x * factor, y * factor, z * factor);
	}

	Point divide(const double& factor) const {
		return multiply(1.0 / factor);
	}

	bool operator<(const Point& other) const {
		return ( x < other.x ) || ( ( x == other.x && y < other.y ) )
                || ( x == other.x && y == other.y && z < other.z );
	}

	bool operator==(const Point& other) const {
		return x == other.x && y == other.y && z == other.z;
	}

	Point& operator=(const Point& other) {
		if ( *this != other ) {
			x = other.x; y = other.y; z = other.z;
		}
		return *this;
	}

	std::string to_string() const {
		return "(" + format(x) + ", " + format(y) + ", " + format(z) + ")";
	}

private:
	std::string format(const double& value) const {
		std::stringstream stream;
		stream << std::fixed << std::setprecision(3) << value;
		return ( value >= 0 ) ? " " + stream.str() : stream.str();
	}

	double x, y, z;
};

// Return the centroid point of the given vector of points.
Point centroid(const std::vector<Point>& points) {
	Point sum;
	for ( const Point& point : points ) {
		sum = sum.add(point);
	}
	return sum.divide(points.size());
}

// An edge of the current Catmull-Clark surface.
class Edge {
public:
	Edge(Point aBegin, Point aEnd) {
		if ( aEnd < aBegin ) {
			std::swap(aBegin, aEnd);
		}
		begin = aBegin; end = aEnd;

		mid_edge = centroid({ begin, end });
		hole_edge = false;
	}

	bool contains(const Point& point) const {
		return point == begin || point == end;
	}

	bool operator<(const Edge other) const {
		return ( begin < other.begin ) || ( begin == other.begin && end < other.end );
	}

	bool operator==(const Edge& other) const {
		return contains(other.begin) && contains(other.end);
	}

	bool hole_edge;
	Point begin, end, mid_edge, edge_point;
};

// A face of the current Catmull-Clark surface.
class Face {
public:
	Face(std::vector<Point> aVertices) {
		vertices = aVertices;
		face_point = centroid(vertices);

		for ( uint64_t i = 0; i < vertices.size() - 1; ++i ) {
			edges.emplace_back(Edge(vertices[i], vertices[i + 1]));
		}
		edges.emplace_back(Edge(vertices.back(), vertices.front()));
	}

	bool contains(const Point& vertex) const {
		return std::find(vertices.begin(), vertices.end(), vertex) != vertices.end();
	}

	bool contains(Edge edge) const {
		return contains(edge.begin) && contains(edge.end);
	}

	std::string toString() const {
		std::string result = "Face: ";
		for ( uint64_t i = 0; i < vertices.size() - 1; ++i ) {
			result += vertices[i].to_string() + ", ";
		}
		return result + vertices.back().to_string();
	}

	std::vector<Point> vertices;
	std::vector<Edge> edges;
	Point face_point;
};

// Return a map containing, for each vertex,
// the new vertex created by the current iteration of the Catmull-Clark surface subdivision algorithm.
std::map<Point, Point> next_vertices(const std::vector<Edge>& edges, const std::vector<Face>& faces) {
	std::map<Point, Point> next_vertices = { };
	std::set<Point> vertices = { };
	for ( const Face& face : faces ) {
		for ( const Point& vertex : face.vertices ) {
			vertices.emplace(vertex);
		}
	}

	for ( const Point& vertex : vertices ) {
		std::vector<Face> faces_for_vertex = { };
		for ( const Face& face : faces ) {
			if ( face.contains(vertex) ) {
				faces_for_vertex.emplace_back(face);
			}
		}

		std::set<Edge> edges_for_vertex = { };
		for ( const Edge& edge : edges ) {
			if ( edge.contains(vertex) ) {
				edges_for_vertex.emplace(edge);
			}
		}

		if ( faces_for_vertex.size() != edges_for_vertex.size() ) {
			std::vector<Point> mid_edge_of_hole_edges = { };
			for ( const Edge& edge : edges_for_vertex ) {
				if ( edge.hole_edge ) {
					mid_edge_of_hole_edges.emplace_back(edge.mid_edge);
				}
			}
			mid_edge_of_hole_edges.emplace_back(vertex);
			next_vertices[vertex] = centroid(mid_edge_of_hole_edges);
		} else {
	        const uint64_t face_count = faces_for_vertex.size();
	        const double multiple_1 = static_cast<double>(( face_count - 3 ) / face_count);
	        const double multiple_2 = 1.0 / face_count;
	        const double multiple_3 = 2.0 / face_count;

	        Point next_vertex_1 = vertex.multiply(multiple_1);
	        std::vector<Point> face_points = { };
	        for ( const Face& face : faces_for_vertex ) {
	        	face_points.emplace_back(face.face_point);
	        }
	        Point next_vertex_2 = centroid(face_points).multiply(multiple_2);
	        std::vector<Point> mid_edges = { };
	        for ( const Edge& edge : edges_for_vertex ) {
	        	mid_edges.emplace_back(edge.mid_edge);
	        }
	        Point next_vertex_3 = centroid(mid_edges).multiply(multiple_3);
	        Point next_vertex_4 = next_vertex_1.add(next_vertex_2);

	        next_vertices[vertex] = next_vertex_4.add(next_vertex_3);
		}
	}
	return next_vertices;
}

// The Catmull-Clarke surface subdivision algorithm.
std::vector<Face> catmull_clark_surface_subdivision(std::vector<Face>& faces) {
	// Determine, for each edge, whether or not it is an edge of a hole, and set its edge point accordingly.
	for ( Face& face : faces ) {
		for ( Edge& edge : face.edges ) {
			std::vector<Point> face_points_for_edge = { };
			for ( const Face& search_face : faces ) {
				if ( search_face.contains(edge) ) {
					face_points_for_edge.emplace_back(search_face.face_point);
				}
			}

			if ( face_points_for_edge.size() == 2 ) {
				edge.hole_edge = false;
				edge.edge_point = centroid({ edge.mid_edge, centroid(face_points_for_edge) });
			} else {
				edge.hole_edge = true;
				edge.edge_point = edge.mid_edge;
			}
		}
	}

	std::vector<Edge> edges = { };
	for ( const Face& face : faces ) {
		for ( const Edge& edge : face.edges ) {
			edges.emplace_back(edge);
		}
	}
	std::map<Point, Point> next_vertex_map = next_vertices(edges, faces);

	std::vector<Face> next_faces = { };
	for ( Face face : faces ) { // The face may contain any number of points
		if ( face.vertices.size() >= 3 ) { // A face with 2 or fewer points does not contribute to the surface
			Point face_point = face.face_point;
			for ( uint64_t i = 0; i < face.vertices.size(); ++i ) {
				next_faces.emplace_back(Face({
					next_vertex_map[face.vertices[i]],
					face.edges[i].edge_point,
					face_point,
					face.edges[( i - 1 + face.vertices.size() ) % face.vertices.size()].edge_point}));
			}
		}
	}
	return next_faces;
}

// Display the current Catmull-Clark surface on the console.
void displaySurface(const std::vector<Face> faces) {
	std::cout << "Surface {" << std::endl;
	for ( const Face& face : faces ) {
		std::cout << face.toString() << std::endl;
	}
	std::cout << "}" << std::endl << std::endl;
}

int main() {
	std::vector<Face> faces = {
		Face({ Point(-1.0,  1.0,  1.0), Point(-1.0, -1.0,  1.0), Point( 1.0, -1.0,  1.0), Point( 1.0,  1.0,  1.0) }),
		Face({ Point( 1.0,  1.0,  1.0), Point( 1.0, -1.0,  1.0), Point( 1.0, -1.0, -1.0), Point( 1.0,  1.0, -1.0) }),
		Face({ Point( 1.0,  1.0, -1.0), Point( 1.0, -1.0, -1.0), Point(-1.0, -1.0, -1.0), Point(-1.0,  1.0, -1.0) }),
		Face({ Point(-1.0,  1.0, -1.0), Point(-1.0,  1.0,  1.0), Point( 1.0,  1.0,  1.0), Point( 1.0,  1.0, -1.0) }),
		Face({ Point(-1.0,  1.0, -1.0), Point(-1.0, -1.0, -1.0), Point(-1.0, -1.0,  1.0), Point(-1.0,  1.0,  1.0) }),
		Face({ Point(-1.0, -1.0, -1.0), Point(-1.0, -1.0,  1.0), Point( 1.0, -1.0,  1.0), Point( 1.0, -1.0, -1.0) })};

	displaySurface(faces);
	const uint32_t iterations = 1;
	for ( uint32_t i = 0; i < iterations; ++i ) {
		faces = catmull_clark_surface_subdivision(faces);
	}
	displaySurface(faces);
}
