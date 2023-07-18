#include <cmath>
#include <iomanip>
#include <iostream>
#include <stack>
#include <tuple>
#include <vector>

const double TOLERANCE = 0.000'000'1;
const double SPACING = 10 * TOLERANCE;

typedef std::pair<double, double> point;

class quad_spline {
public:
	quad_spline(double c0, double c1, double c2) : c0(c0), c1(c1), c2(c2) {};
	quad_spline() : c0(0.0), c1(0.0), c2(0.0) {};
	double c0, c1, c2;
};

class quad_curve {
public:
	quad_curve(quad_spline x, quad_spline y) : x(x), y(y) {};
	quad_curve() : x(quad_spline()), y(quad_spline()) {};
	quad_spline x, y;
};

// de Casteljau's algorithm
void subdivide_quad_spline(const quad_spline& q, const double& t, quad_spline& u, quad_spline& v) {
	const double s = 1.0 - t;
	u.c0 = q.c0;
	v.c2 = q.c2;
	u.c1 = s * q.c0 + t * q.c1;
	v.c1 = s * q.c1 + t * q.c2;
	u.c2 = s * u.c1 + t * v.c1;
	v.c0 = u.c2;
}

void subdivide_quad_curve(const quad_curve& q, const double t, quad_curve& u, quad_curve& v) {
	subdivide_quad_spline(q.x, t, u.x, v.x);
	subdivide_quad_spline(q.y, t, u.y, v.y);
}

bool rectangles_overlap(const double& xa0, const double& ya0, const double& xa1, const double& ya1,
					    const double& xb0, const double& yb0, const double& xb1, const double& yb1) {
	return xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1;
}

std::tuple<bool, bool, point> test_intersection(const quad_curve& p, const quad_curve& q) {
	const double px_min = std::min(std::min(p.x.c0, p.x.c1), p.x.c2);
	const double py_min = std::min(std::min(p.y.c0, p.y.c1), p.y.c2);
	const double px_max = std::max(std::max(p.x.c0, p.x.c1), p.x.c2);
	const double py_max = std::max(std::max(p.y.c0, p.y.c1), p.y.c2);

	const double qx_min = std::min(std::min(q.x.c0, q.x.c1), q.x.c2);
	const double qy_min = std::min(std::min(q.y.c0, q.y.c1), q.y.c2);
	const double qx_max = std::max(std::max(q.x.c0, q.x.c1), q.x.c2);
	const double qy_max = std::max(std::max(q.y.c0, q.y.c1), q.y.c2);

	bool accepted = false;
	bool excluded = true;
	point intersect = std::make_pair(0.0, 0.0);

	if ( rectangles_overlap(px_min, py_min, px_max, py_max, qx_min, qy_min, qx_max, qy_max) ) {
		excluded = false;
		const double x_min = std::max(px_min, qx_min);
		const double x_max = std::min(px_max, px_max);
		if ( x_max - x_min <= TOLERANCE ) {
			const double y_min = std::max(py_min, qy_min);
			const double y_max = std::min(py_max, qy_max);
			if ( y_max - y_min <= TOLERANCE ) {
				accepted = true;
				intersect = std::make_pair(0.5 * ( x_min + x_max ), 0.5 * ( y_min + y_max));
			}
		}
	}
	return std::make_tuple(accepted, excluded, intersect);
}

bool seems_to_be_duplicate(const std::vector<point>& intersects, const point& pt) {
	for ( point intersect : intersects ) {
		if ( fabs(intersect.first - pt.first) < SPACING && fabs(intersect.second - pt.second) < SPACING ) {
			return true;
		}
	}
	return false;
}

std::vector<point> find_intersects(const quad_curve& p, const quad_curve& q) {
	std::vector<point> result;
	std::stack<quad_curve> stack;
	stack.push(p);
	stack.push(q);

	while ( ! stack.empty() ) {
		quad_curve pp = stack.top();
		stack.pop();
		quad_curve qq = stack.top();
		stack.pop();

		std::tuple<bool, bool, point> objects = test_intersection(pp, qq);
		bool accepted, excluded;
		point intersect;
		std::tie(accepted, excluded, intersect) = objects;

		if ( accepted ) {
			if ( ! seems_to_be_duplicate(result, intersect) ) {
				result.push_back(intersect);
			}
		} else if ( ! excluded ) {
			quad_curve p0{}, q0{}, p1{}, q1{};
			subdivide_quad_curve(pp, 0.5, p0, p1);
			subdivide_quad_curve(qq, 0.5, q0, q1);
			for ( quad_curve item : { p0, q0, p0, q1, p1, q0, p1, q1 } ) {
				stack.push(item);
			}
		}
	}
	return result;
}

int main() {
	quad_curve vertical(quad_spline(-1.0, 0.0, 1.0), quad_spline(0.0, 10.0, 0.0));
	// QuadCurve vertical represents the Bezier curve having control points (-1, 0), (0, 10) and (1, 0)
	quad_curve horizontal(quad_spline(2.0, -8.0, 2.0), quad_spline(1.0, 2.0, 3.0));
	// QuadCurve horizontal represents the Bezier curve having control points (2, 1), (-8, 2) and (2, 3)

	std::cout << "The points of intersection are:" << std::endl;
	std::vector<point> intersects = find_intersects(vertical, horizontal);
	for ( const point& intersect : intersects ) {
		std::cout << "( " << std::setw(9) << std::setprecision(6) << intersect.first
				  << ", " << intersect.second << " )" << std::endl;
	}
}
