#[derive(Copy, Clone)]
struct Point {
    x: f64,
    y: f64,
}

use std::fmt;

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

// Returns the distance from point p to the line between p1 and p2
fn perpendicular_distance(p: &Point, p1: &Point, p2: &Point) -> f64 {
    let dx = p2.x - p1.x;
    let dy = p2.y - p1.y;
    (p.x * dy - p.y * dx + p2.x * p1.y - p2.y * p1.x).abs() / dx.hypot(dy)
}

fn rdp(points: &[Point], epsilon: f64, result: &mut Vec<Point>) {
    let n = points.len();
    if n < 2 {
        return;
    }
    let mut max_dist = 0.0;
    let mut index = 0;
    for i in 1..n - 1 {
        let dist = perpendicular_distance(&points[i], &points[0], &points[n - 1]);
        if dist > max_dist {
            max_dist = dist;
            index = i;
        }
    }
    if max_dist > epsilon {
        rdp(&points[0..=index], epsilon, result);
        rdp(&points[index..n], epsilon, result);
    } else {
        result.push(points[n - 1]);
    }
}

fn ramer_douglas_peucker(points: &[Point], epsilon: f64) -> Vec<Point> {
    let mut result = Vec::new();
    if points.len() > 0 && epsilon >= 0.0 {
        result.push(points[0]);
        rdp(points, epsilon, &mut result);
    }
    result
}

fn main() {
    let points = vec![
        Point { x: 0.0, y: 0.0 },
        Point { x: 1.0, y: 0.1 },
        Point { x: 2.0, y: -0.1 },
        Point { x: 3.0, y: 5.0 },
        Point { x: 4.0, y: 6.0 },
        Point { x: 5.0, y: 7.0 },
        Point { x: 6.0, y: 8.1 },
        Point { x: 7.0, y: 9.0 },
        Point { x: 8.0, y: 9.0 },
        Point { x: 9.0, y: 9.0 },
    ];
    for p in ramer_douglas_peucker(&points, 1.0) {
        println!("{}", p);
    }
}
