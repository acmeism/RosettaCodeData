use std::f64;

const TOLERANCE: f64 = 0.000_000_1;
const SPACING: f64 = 10.0 * TOLERANCE;

// Replaces std::pair<double, double>
#[derive(Debug, Clone, Copy, PartialEq, Default)]
struct Point {
    x: f64,
    y: f64,
}

impl Point {
    fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}

// Replaces quad_spline class
#[derive(Debug, Clone, Copy, Default)]
struct QuadSpline {
    c0: f64,
    c1: f64,
    c2: f64,
}

impl QuadSpline {
    fn new(c0: f64, c1: f64, c2: f64) -> Self {
        QuadSpline { c0, c1, c2 }
    }

    /// de Casteljau's algorithm for 1D spline subdivision
    /// Returns two new splines, representing the curve from 0->t and t->1
    fn subdivide(&self, t: f64) -> (QuadSpline, QuadSpline) {
        let s = 1.0 - t;
        let u_c0 = self.c0;
        let v_c2 = self.c2;
        let u_c1 = s * self.c0 + t * self.c1;
        let v_c1 = s * self.c1 + t * self.c2;
        let u_c2 = s * u_c1 + t * v_c1;
        let v_c0 = u_c2;

        let u = QuadSpline::new(u_c0, u_c1, u_c2);
        let v = QuadSpline::new(v_c0, v_c1, v_c2);
        (u, v)
    }

    // Helper to get min/max control points for bounding box
    fn min_max(&self) -> (f64, f64) {
        let min_val = self.c0.min(self.c1).min(self.c2);
        let max_val = self.c0.max(self.c1).max(self.c2);
        (min_val, max_val)
    }
}

// Replaces quad_curve class
#[derive(Debug, Clone, Copy, Default)]
struct QuadCurve {
    x: QuadSpline,
    y: QuadSpline,
}

impl QuadCurve {
    fn new(x: QuadSpline, y: QuadSpline) -> Self {
        QuadCurve { x, y }
    }

    /// de Casteljau's algorithm for 2D curve subdivision
    /// Returns two new curves, representing the curve from 0->t and t->1
    fn subdivide(&self, t: f64) -> (QuadCurve, QuadCurve) {
        let (ux, vx) = self.x.subdivide(t);
        let (uy, vy) = self.y.subdivide(t);
        (QuadCurve::new(ux, uy), QuadCurve::new(vx, vy))
    }

    /// Calculate the axis-aligned bounding box (AABB)
    fn bounding_box(&self) -> (f64, f64, f64, f64) {
        let (px_min, px_max) = self.x.min_max();
        let (py_min, py_max) = self.y.min_max();
        (px_min, py_min, px_max, py_max)
    }
}

/// Checks if two axis-aligned rectangles overlap
fn rectangles_overlap(
    xa0: f64, ya0: f64, xa1: f64, ya1: f64,
    xb0: f64, yb0: f64, xb1: f64, yb1: f64,
) -> bool {
    // Ensure coordinates are ordered min -> max if necessary, although bounding_box should handle this.
    // let (xa0, xa1) = if xa0 > xa1 { (xa1, xa0) } else { (xa0, xa1) };
    // let (ya0, ya1) = if ya0 > ya1 { (ya1, ya0) } else { (ya0, ya1) };
    // let (xb0, xb1) = if xb0 > xb1 { (xb1, xb0) } else { (xb0, xb1) };
    // let (yb0, yb1) = if yb0 > yb1 { (yb1, yb0) } else { (yb0, yb1) };

    xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1
}

/// Test intersection candidacy based on bounding box overlap and size.
/// Returns: (accepted, excluded, potential_intersect_point)
fn test_intersection(p: &QuadCurve, q: &QuadCurve) -> (bool, bool, Point) {
    let (px_min, py_min, px_max, py_max) = p.bounding_box();
    let (qx_min, qy_min, qx_max, qy_max) = q.bounding_box();

    let mut accepted = false;
    let mut excluded = true;
    let mut intersect = Point::default(); // Default point (0.0, 0.0)

    if rectangles_overlap(px_min, py_min, px_max, py_max, qx_min, qy_min, qx_max, qy_max) {
        excluded = false;
        // Calculate overlap region
        let x_min = px_min.max(qx_min);
        let x_max = px_max.min(qx_max); // Corrected from C++ possible typo px_max.min(px_max)
        if x_max - x_min <= TOLERANCE {
            let y_min = py_min.max(qy_min);
            let y_max = py_max.min(qy_max);
            if y_max - y_min <= TOLERANCE {
                accepted = true;
                // Use midpoint of the tiny overlap box as the intersection point
                intersect = Point::new(0.5 * (x_min + x_max), 0.5 * (y_min + y_max));
            }
        }
    }
    (accepted, excluded, intersect)
}

/// Check if a point is too close to existing intersection points
fn seems_to_be_duplicate(intersects: &[Point], pt: Point) -> bool {
    for &intersect in intersects {
        if (intersect.x - pt.x).abs() < SPACING && (intersect.y - pt.y).abs() < SPACING {
            return true;
        }
    }
    false
}

/// Find intersection points between two quadratic Bezier curves using recursive subdivision.
fn find_intersects(p: &QuadCurve, q: &QuadCurve) -> Vec<Point> {
    let mut result: Vec<Point> = Vec::new();
    // Use a Vec as a stack, storing pairs of curves to check
    // Pushing/popping individual curves to mimic C++ stack behavior exactly
    let mut stack: Vec<QuadCurve> = Vec::new();
    stack.push(*q); // Push q first (will be popped as qq)
    stack.push(*p); // Push p second (will be popped as pp)

    while stack.len() >= 2 {
        // Pop in the order that matches the C++ version's stack processing
        let pp = stack.pop().unwrap(); // Pop p-curve segment
        let qq = stack.pop().unwrap(); // Pop q-curve segment

        let (accepted, excluded, intersect) = test_intersection(&pp, &qq);

        if accepted {
            if !seems_to_be_duplicate(&result, intersect) {
                result.push(intersect);
            }
        } else if !excluded {
            // Bounding boxes overlap significantly, subdivide both curves
            let (p0, p1) = pp.subdivide(0.5);
            let (q0, q1) = qq.subdivide(0.5);

            // Push the 4 pairs of sub-curves onto the stack for further testing.
            // Order matches the C++ version's push order { p0, q0, p0, q1, p1, q0, p1, q1 }
            // Processed pairs will be (p0,q0), (p0,q1), (p1,q0), (p1,q1) eventually.
            // Push in reverse order of desired processing:
            stack.push(q1); stack.push(p1); // For pair (p1, q1)
            stack.push(q0); stack.push(p1); // For pair (p1, q0)
            stack.push(q1); stack.push(p0); // For pair (p0, q1)
            stack.push(q0); stack.push(p0); // For pair (p0, q0)
        }
        // If excluded, do nothing, this pair of segments cannot intersect.
    }
    result
}

fn main() {
    // QuadCurve vertical represents the Bezier curve having control points (-1, 0), (0, 10) and (1, 0)
    let vertical = QuadCurve::new(
        QuadSpline::new(-1.0, 0.0, 1.0),
        QuadSpline::new(0.0, 10.0, 0.0),
    );
    // QuadCurve horizontal represents the Bezier curve having control points (2, 1), (-8, 2) and (2, 3)
    let horizontal = QuadCurve::new(
        QuadSpline::new(2.0, -8.0, 2.0),
        QuadSpline::new(1.0, 2.0, 3.0),
    );

    println!("The points of intersection are:");
    let intersects = find_intersects(&vertical, &horizontal);

    if intersects.is_empty() {
        println!("No intersections found.");
    } else {
        for intersect in intersects {
            // Format output similar to C++ version
            println!("( {:9.6}, {:9.6} )", intersect.x, intersect.y);
        }
    }
}
