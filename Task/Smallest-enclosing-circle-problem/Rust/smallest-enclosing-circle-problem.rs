use rand::seq::SliceRandom;
use rand::thread_rng;

#[derive(Debug, Clone, Copy)]
struct Point {
    x: f64,
    y: f64,
}

impl Point {
    fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}

#[derive(Debug, Clone, Copy)]
struct Circle {
    centre: Point,
    radius: f64,
}

impl Circle {
    fn new(centre: Point, radius: f64) -> Self {
        Circle { centre, radius }
    }
}

fn distance(a: &Point, b: &Point) -> f64 {
    ((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)).sqrt()
}

fn encloses(point: &Point, circle: &Circle) -> bool {
    distance(point, &circle.centre) <= circle.radius
}

fn circle_from_two_points(a: &Point, b: &Point) -> Circle {
    let centre = Point::new((a.x + b.x) / 2.0, (a.y + b.y) / 2.0);
    Circle::new(centre, distance(a, b) / 2.0)
}

fn circle_from_three_points(a: &Point, b: &Point, c: &Point) -> Circle {
    let ba = Point::new(b.x - a.x, b.y - a.y);
    let ca = Point::new(c.x - a.x, c.y - a.y);
    let bb = ba.x * ba.x + ba.y * ba.y;
    let cc = ca.x * ca.x + ca.y * ca.y;
    let dd = (ba.x * ca.y - ba.y * ca.x) * 2.0;
    let centre = Point::new(
        (ca.y * bb - ba.y * cc) / dd + a.x,
        (ba.x * cc - ca.x * bb) / dd + a.y,
    );
    Circle::new(centre, distance(&centre, a))
}

fn smallest_enclosing_circle(points: &[Point]) -> Result<Circle, &'static str> {
    match points.len() {
        0 => Ok(Circle::new(Point::new(0.0, 0.0), 0.0)),
        1 => Ok(Circle::new(points[0], 0.0)),
        2 => Ok(circle_from_two_points(&points[0], &points[1])),
        3 => Ok(circle_from_three_points(&points[0], &points[1], &points[2])),
        _ => Err("Error: too many points on circle boundary"),
    }
}

fn welzl_recursive(mut points: Vec<Point>, boundary: Vec<Point>) -> Result<Circle, &'static str> {
    // Base case occurs when all the points have been processed
    // or the smallest enclosing circle boundary is specified by three points
    if points.is_empty() || boundary.len() == 3 {
        return smallest_enclosing_circle(&boundary);
    }

    // Choose a random point from the given 'points', since 'points' has already been shuffled
    let point = points.pop().unwrap();

    // Recurse with the chosen point removed
    let candidate = welzl_recursive(points.clone(), boundary.clone())?;

    if encloses(&point, &candidate) {
        return Ok(candidate);
    }

    // Otherwise, 'point' must be on the boundary of the smallest enclosing circle
    let mut new_boundary = boundary;
    new_boundary.push(point);

    // Recurse with the chosen point removed from 'points' and added to the 'boundary'
    welzl_recursive(points, new_boundary)
}

// Return the smallest enclosing circle using Welzl's algorithm
fn welzl(points: &[Point]) -> Result<Circle, &'static str> {
    let mut points_copy = points.to_vec();
    let mut rng = thread_rng();
    points_copy.shuffle(&mut rng);
    welzl_recursive(points_copy, Vec::new())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let tests = vec![
        vec![
            Point::new(0.0, 0.0),
            Point::new(0.0, 1.0),
            Point::new(1.0, 0.0),
        ],
        vec![
            Point::new(5.0, -2.0),
            Point::new(-3.0, -2.0),
            Point::new(-2.0, 5.0),
            Point::new(1.0, 6.0),
            Point::new(0.0, 2.0),
        ],
        vec![
            Point::new(0.0, 0.0),
            Point::new(-2.0, -1.0),
            Point::new(3.0, -4.0),
            Point::new(2.0, 8.0),
            Point::new(3.0, 11.0),
            Point::new(-8.0, -2.0),
            Point::new(-14.0, -6.0),
            Point::new(7.0, 3.0),
            Point::new(10.0, 4.0),
            Point::new(-1.0, 4.0),
        ],
    ];

    for test in &tests {
        let circle = welzl(test)?;
        println!(
            "Centre: ({}, {}), Radius: {}",
            circle.centre.x, circle.centre.y, circle.radius
        );
    }

    Ok(())
}

// #[cfg(test)]
// mod tests {
//     use super::*;

//     #[test]
//     fn test_distance() {
//         let a = Point::new(0.0, 0.0);
//         let b = Point::new(3.0, 4.0);
//         assert_eq!(distance(&a, &b), 5.0);
//     }

//     #[test]
//     fn test_encloses() {
//         let circle = Circle::new(Point::new(0.0, 0.0), 5.0);
//         let point_inside = Point::new(3.0, 4.0);
//         let point_outside = Point::new(6.0, 0.0);

//         assert!(encloses(&point_inside, &circle));
//         assert!(!encloses(&point_outside, &circle));
//     }

//     #[test]
//     fn test_circle_from_two_points() {
//         let a = Point::new(0.0, 0.0);
//         let b = Point::new(4.0, 0.0);
//         let circle = circle_from_two_points(&a, &b);

//         assert_eq!(circle.centre.x, 2.0);
//         assert_eq!(circle.centre.y, 0.0);
//         assert_eq!(circle.radius, 2.0);
//     }
// }
