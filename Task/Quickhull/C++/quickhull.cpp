#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

constexpr uint32_t MAX_SIZE = 2'500;
constexpr double EPSILON = 0.000'000'01;

// Numerical utilities
bool is_greater_than(const double& a, const double& b) {
	return ( a - b ) > EPSILON;
}

bool is_equal(const double& a, const double& b) {
	return std::abs(a - b) < EPSILON;
}

class Vector {
public:
   Vector(const double& x = 0, const double& y = 0, const double& z = 0, const uint32_t& id = 0)
   	   : x(x), y(y), z(z), id(id) {}

   Vector subtract(const Vector& other) const {
	   return Vector(x - other.x, y - other.y, z - other.z);
   }

   Vector vector_product(const Vector& other) const {
	   return Vector(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);
   }

   double scalar_product(const Vector& other) const {
	   return x * other.x + y * other.y + z * other.z;
   }

   double magnitude() const {
	   return std::sqrt(x * x + y * y + z * z);
   }

   bool equals(const Vector& b) const {
	   return is_equal(x, b.x) && is_equal(y, b.y) && is_equal(z, b.z);
   }

   double x, y, z;
   uint32_t id;
};

class Line {
public:
    Line(const Vector& u, const Vector& v) : u(u), v(v) {}

	Vector u, v;
};

class Plane {
public:
   Plane(const Vector& u, const Vector& v, const Vector& w) : u(u), v(v), w(w) {}

   Plane() {}

   Vector normal() const {
	   return v.subtract(u).vector_product(w.subtract(u));
   }

   Vector vector_at_index(const uint32_t& i) const {
	   if ( i == 0 ) { return u; }
	   if ( i == 1 ) { return v; }
	   if ( i == 2 ) { return w; }
	   return 0;
   }

   uint32_t vector_id(const uint32_t& i) const {
	   return vector_at_index(i).id;
   }

   Vector u, v, w;
};

class Facet {
public:
	Facet(const uint32_t& id, const Plane& p) : id(id), plane(p) {}

	Facet(const uint32_t& id) : id(id) {}

	Facet() {}

	std::vector<uint32_t> N;
	uint32_t id = 0;
	uint32_t visited_time = 0;
	bool is_deleted = false;
	Plane plane;
};

class Edge {
public:
	Edge() {}

	uint32_t netID = 0;
	uint32_t faceID = 0;
};

// Global variables
std::vector<Facet> facets;
std::vector<std::vector<Vector>> hull_points;
uint32_t time_step = 0;
std::vector<std::vector<Edge>> edges = { 2, std::vector<Edge>(MAX_SIZE) };
std::vector<uint32_t> visit_time(MAX_SIZE, 0);
std::vector<uint32_t> queue;
std::vector<uint32_t> resfnew;
std::vector<uint32_t> resfdel;
std::vector<Vector> respt;

// Geometric utilities
double distance_point_plane(const Vector& vec, const Plane& plane) {
	const double num = vec.subtract(plane.u).scalar_product(plane.normal());
	const double den = plane.normal().magnitude();
	return num / den;
}

double distance_point_line(const Vector& vec, const Line& line) {
	const double length = vec.subtract(line.u).magnitude();
	return ( length == 0.0 ) ? 0.0 :
		line.v.subtract(line.u).vector_product(vec.subtract(line.u)).magnitude() / line.v.subtract(line.u).magnitude();
}

double distance_point_point(const Vector& a, const Vector& b) {
	return a.subtract(b).magnitude();
}

bool is_above(const Vector& point, const Plane& plane) {
    return is_greater_than(point.subtract(plane.u).scalar_product(plane.normal()), 0.0);
}

class ConvexHulls3d {
public:
	ConvexHulls3d(const uint32_t& index) : index(index) {}

	double get_surface_area() {
		if ( is_greater_than(surface_area, 0.0) ) {
			return surface_area;
		}

		time_step++;
		dfs_area(index);
		return surface_area;
	}

	uint32_t get_horizon(const uint32_t& f, const Vector& point, std::vector<uint32_t> resDel) const {
		Facet Ff = facets[f];
		if ( ! is_above(point, Ff.plane) ) {
			return 0;
		}
		if ( Ff.visited_time == time_step ) {
			return -1;
		}

		Ff.visited_time = time_step;
		Ff.is_deleted = true;
		resDel.emplace_back(Ff.id);
		uint32_t result = -2;
		for ( uint32_t i = 0; i < 3; ++i ) {
			const uint32_t ni = Ff.N[i];
			const int32_t horizon = get_horizon(ni, point, resDel);
			if ( horizon == 0 ) {
				const uint32_t a = facets[f].plane.vector_id(i);
				const uint32_t b = facets[f].plane.vector_id((i + 1) % 3);
				for ( uint32_t idx = 0; idx < 2; ++idx ) {
					const uint32_t pt = ( idx == 0 ) ? a : b;
					const uint32_t facet = ni;
					if ( visit_time[pt] != time_step ) {
						visit_time[pt] = time_step;
						edges[0][pt].netID = ( idx == 0 ) ? b : a;
						edges[0][pt].faceID = facet;
					} else {
						edges[1][pt].netID = ( idx == 0 ) ? b : a;
						edges[1][pt].faceID = facet;
					}
				}
				result = a;
			} else if ( horizon != -1 && horizon != -2 ) {
				result = horizon;
			}
		}
		return result;
	}

	uint32_t index;
	double surface_area = 0.0;

private:
	void dfs_area(const uint32_t& f) {
		if ( facets[f].visited_time == time_step ) {
			return;
		}

		facets[f].visited_time = time_step;
		const Vector normal = facets[f].plane.normal();
		surface_area += normal.magnitude() / 2.0;
		for ( uint32_t i = 0; i < 3; ++i ) {
			dfs_area(facets[f].N[i]);
		}
	}
};

void prepareConvexHulls() {
   // Reserve index 0
   hull_points.emplace_back(std::vector<Vector>());
   facets.emplace_back(Facet());

   // Initialize edge vector
   for ( uint32_t i = 0; i < 2; ++i ) {
	   for ( uint32_t j = 0; j < MAX_SIZE; ++j ) {
		   edges[i][j] = Edge();
	   }
   }
}

ConvexHulls3d get_initial_hull(const std::vector<Vector>& points, const uint32_t& total_points) {
	std::vector<Vector> extremes(6);
	for ( uint32_t i = 0; i < 6; ++i ) { extremes[i] = points[1]; }
	for ( uint32_t i = 1; i <= total_points; ++i ) {
		Vector point = points[i];
		if ( is_greater_than(point.x, extremes[0].x) ) { extremes[0] = point; }
		if ( is_greater_than(extremes[1].x, point.x) ) { extremes[1] = point; }
		if ( is_greater_than(point.y, extremes[2].y) ) { extremes[2] = point; }
		if ( is_greater_than(extremes[3].y, point.y) ) { extremes[3] = point; }
		if ( is_greater_than(point.z, extremes[4].z) ) { extremes[4] = point; }
		if ( is_greater_than(extremes[5].z, point.z) ) { extremes[5] = point; }
	}

	// Furthest pair
	Vector extreme0 = extremes[0];
	Vector extreme1 = extremes[1];
	for ( uint32_t i = 0; i < 6; ++i ) {
		for ( uint32_t j = i + 1; j < 6; ++j ) {
			const double distance = distance_point_point(extremes[i], extremes[j]);
			if ( is_greater_than(distance, distance_point_point(extreme0, extreme1)) ) {
				extreme0 = extremes[i];
				extreme1 = extremes[j];
			}
		}
	}

	// Furthest from line
	const Line line(extreme0, extreme1);
	Vector extreme2 = extremes[0];
	for ( uint32_t i = 0; i < 6; ++i ) {
		if ( is_greater_than(distance_point_line(extremes[i], line), distance_point_line(extreme2, line)) ) {
			extreme2 = extremes[i];
		}
	}

	// Furthest from plane
	Vector extreme3 = points[1];
	const Plane basePlane(extreme0, extreme1, extreme2);
	for ( uint32_t i = 1; i <= total_points; ++i ) {
		const double distance1 = std::fabs(distance_point_plane(points[i], basePlane));
		const double distance2 = std::fabs(distance_point_plane(extreme3, basePlane));
		if ( is_greater_than(distance1, distance2) ) {
			extreme3 = points[i];
		}
	}

	if ( is_greater_than(0, distance_point_plane(extreme3, basePlane)) ) {
		std::swap(extreme1, extreme2);
	}

	// Create 4 initial facets
	std::vector<uint32_t> f(4);
	for ( uint32_t i = 0; i < 4; ++i ) {
		facets.emplace_back(Facet(facets.size()));
		f[i] = facets.size() - 1;
	}

	facets[f[0]].plane = Plane(extreme0, extreme2, extreme1);
	facets[f[1]].plane = Plane(extreme0, extreme1, extreme3);
	facets[f[2]].plane = Plane(extreme1, extreme2, extreme3);
	facets[f[3]].plane = Plane(extreme2, extreme0, extreme3);

	facets[f[0]].N = { f[3], f[2], f[1] };
	facets[f[1]].N = { f[0], f[2], f[3] };
	facets[f[2]].N = { f[0], f[3], f[1] };
	facets[f[3]].N = { f[0], f[1], f[2] };

	// Prepare hull_points vector
	for ( uint32_t i = 0; i < 4; ++i ) {
		hull_points.emplace_back(std::vector<Vector>());
	}

	// Assign points
	for ( uint32_t i = 1; i <= total_points; ++i ) {
		const Vector point = points[i];
		if ( point.equals(extreme0) || point.equals(extreme1) || point.equals(extreme2) || point.equals(extreme3) ) {
			continue;
		}

		for ( uint32_t j = 0; j < 4; ++j ) {
			if ( is_above(point, facets[f[j]].plane) ) {
				hull_points[f[j]].emplace_back(point);
				break;
			}
		}
	}

	return ConvexHulls3d(f[0]);
}

ConvexHulls3d QuickHull3D(const std::vector<Vector>& points, const uint32_t& total_points) {
	ConvexHulls3d hull = get_initial_hull(points, total_points);

	// Initialize queue
	queue.clear();
	queue.emplace_back(hull.index);
	for ( uint32_t i = 0; i < 3; ++i ) {
		queue.emplace_back(facets[hull.index].N[i]);
	}

	uint32_t new_horizon = 0;

	while ( ! queue.empty() ) {
		uint32_t nf = queue.front();
		queue.erase(queue.begin());
		if ( facets[nf].is_deleted || hull_points[nf].empty()) {
			if ( ! facets[nf].is_deleted ) {
				new_horizon = nf;
			}
			continue;
		}

		// Farthest point
		Vector point = hull_points[nf][0];
		for ( const Vector& vec : hull_points[nf] ) {
			if ( is_greater_than(distance_point_plane(vec, facets[nf].plane),
								 distance_point_plane(point, facets[nf].plane)) ) {
				point = vec;
			}
		}

		// Find horizon
		time_step++;
		resfdel.clear();
		uint32_t horizon = hull.get_horizon(nf, point, resfdel);

		// Build new faces
		resfnew.clear();
		time_step++;
		uint32_t from = -1;
		uint32_t last_f = -1;
		uint32_t first_f = -1;
		while ( visit_time[horizon] != time_step ) {
			visit_time[horizon] = time_step;
			uint32_t net;
			uint32_t f;
			uint32_t new_f;
			if ( edges[0][horizon].netID == from ) {
				net = edges[1][horizon].netID;
				f = edges[1][horizon].faceID;
			} else {
				net = edges[0][horizon].netID;
				f = edges[0][horizon].faceID;
			}

			// Find indices on facet f
			uint32_t pt1 = 0;
			uint32_t pt2 = 0;
			for ( uint32_t i = 0; i < 3; ++i ) {
				if ( points[horizon].equals(facets[f].plane.vector_at_index(i)) ) {
					pt1 = i;
				}
				if ( points[net].equals(facets[f].plane.vector_at_index(i)) ) {
					pt2 = i;
				}
			}
			if ( ( pt1 + 1 ) % 3 != pt2 ) {
				std::swap(pt1, pt2);
			}

			// Create new facet
			facets.emplace_back(Facet(
					facets.size(),
					Plane(facets[f].plane.vector_at_index(pt2),
					facets[f].plane.vector_at_index(pt1), point)));
			new_f = facets.size() - 1;
			hull_points.emplace_back(std::vector<Vector>());
			resfnew.emplace_back(new_f);

			facets[new_f].N[0] = f;
			facets[f].N[pt1] = new_f;

			if ( last_f >= 0 ) {
				// Link with previous new facet
				if ( facets[new_f].plane.vector_at_index(1).equals(facets[last_f].plane.u) ) {
					facets[new_f].N[1] = last_f;
					facets[last_f].N[2] = new_f;
				} else {
					facets[new_f].N[2] = last_f;
					facets[last_f].N[1] = new_f;
				}
			} else {
				first_f = new_f;
			}

			last_f = new_f;
			from = horizon;
			horizon = net;
		}

		// Close the loop
		if ( facets[first_f].plane.vector_at_index(1).equals(facets[last_f].plane.u) ) {
			facets[first_f].N[1] = last_f;
			facets[last_f].N[2] = first_f;
		} else {
			facets[first_f].N[2] = last_f;
			facets[last_f].N[1] = first_f;
		}

		// Collect deleted points
		respt.clear();
		for ( const uint32_t& f_id : resfdel ) {
			respt.insert(respt.end(), hull_points[f_id].begin(), hull_points[f_id].end());
			hull_points[f_id].clear();
		}

		// Reassign
		for ( const Vector& vec : respt ) {
			if ( vec.equals(point) ) {
				continue;
			}
			for ( const uint32_t& f_id : resfnew ) {
				if ( is_above(vec, facets[f_id].plane) ) {
					hull_points[f_id].emplace_back(vec);
					break;
				}
			}
		}

		// Enqueue new faces
		for ( const uint32_t& f_id : resfnew ) {
			queue.emplace_back(f_id);
		}
	}

	hull.index = new_horizon;
	return hull;
}

int main() {
	prepareConvexHulls();

	// Example: a tetrahedron
	constexpr uint32_t n = 4;
	std::vector<Vector> points(n + 1);
	// An empty or placeholder value for points[0] is required for all examples
	points[1] = Vector(0, 0, 0, 1); // The last argument of each vector is its index
	points[2] = Vector(1, 0, 0, 2);
	points[3] = Vector(0, 1, 0, 3);
	points[4] = Vector(0, 0, 1, 4);

	ConvexHulls3d hull = QuickHull3D(points, n);
	std::cout << std::fixed << std::setprecision(3) << hull.get_surface_area() << std::endl;
}
