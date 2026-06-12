use std::cmp::Ordering;
use std::collections::BTreeSet;
use rand::Rng;
use std::f64;

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

impl PartialEq for Point {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}

impl Eq for Point {}

impl PartialOrd for Point {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        if self.x == other.x {
            self.y.partial_cmp(&other.y)
        } else {
            self.x.partial_cmp(&other.x)
        }
    }
}

impl Ord for Point {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

fn flipped(points: &[Point]) -> Vec<Point> {
    points.iter().map(|point| Point::new(-point.x, -point.y)).collect()
}

// Modified quickselect for f64 values using partial_cmp
fn quickselect_f64(ls: &mut Vec<f64>, index: usize, lo: usize, hi: Option<usize>) -> f64 {
    let hi = hi.unwrap_or(ls.len() - 1);

    if lo == hi {
        return ls[lo];
    }

    let mut rng = rand::thread_rng();
    let pivot = lo + rng.gen_range(0..=hi - lo);
    ls.swap(lo, pivot);

    let mut cur = lo;
    for run in (lo + 1)..=hi {
        if ls[run] < ls[lo] {
            cur += 1;
            ls.swap(cur, run);
        }
    }

    ls.swap(cur, lo);

    if index < cur {
        quickselect_f64(ls, index, lo, Some(cur - 1))
    } else if index > cur {
        quickselect_f64(ls, index, cur + 1, Some(hi))
    } else {
        ls[cur]
    }
}

// Generic quickselect for types that implement Ord
fn quickselect<T: Ord + Copy>(ls: &mut Vec<T>, index: usize, lo: usize, hi: Option<usize>) -> T {
    let hi = hi.unwrap_or(ls.len() - 1);

    if lo == hi {
        return ls[lo];
    }

    let mut rng = rand::thread_rng();
    let pivot = lo + rng.gen_range(0..=hi - lo);
    ls.swap(lo, pivot);

    let mut cur = lo;
    for run in (lo + 1)..=hi {
        if ls[run] < ls[lo] {
            cur += 1;
            ls.swap(cur, run);
        }
    }

    ls.swap(cur, lo);

    if index < cur {
        quickselect(ls, index, lo, Some(cur - 1))
    } else if index > cur {
        quickselect(ls, index, cur + 1, Some(hi))
    } else {
        ls[cur]
    }
}

fn bridge(points: BTreeSet<Point>, vertical_line: f64) -> (Point, Point) {
    let mut candidates = BTreeSet::new();

    if points.len() == 2 {
        let mut iter = points.iter();
        let first = *iter.next().unwrap();
        let second = *iter.next().unwrap();
        return (first, second);
    }

    let mut pairs = Vec::new();
    let mut modify_s = points.clone();

    while modify_s.len() >= 2 {
        let p1 = *modify_s.iter().next().unwrap();
        modify_s.remove(&p1);

        let p2 = *modify_s.iter().next().unwrap();
        modify_s.remove(&p2);

        if p1 < p2 {
            pairs.push((p1, p2));
        } else {
            pairs.push((p2, p1));
        }
    }

    if !modify_s.is_empty() {
        candidates.insert(*modify_s.iter().next().unwrap());
    }

    let mut slopes = Vec::new();
    let mut index = 0;

    while index < pairs.len() {
        let (pi, pj) = pairs[index];

        if pi.x == pj.x {
            candidates.insert(if pi.y > pj.y { pi } else { pj });
            pairs.swap_remove(index);
        } else {
            slopes.push((pi.y - pj.y) / (pi.x - pj.x));
            index += 1;
        }
    }

    if slopes.is_empty() {
        // Handle case when no valid pairs with slopes are found
        if candidates.len() >= 2 {
            let mut iter = candidates.iter();
            let p1 = *iter.next().unwrap();
            let p2 = *iter.next().unwrap();
            return (p1, p2);
        }
        // If we don't have enough candidates, return the first pair
        let mut iter = points.iter();
        let p1 = *iter.next().unwrap();
        let p2 = *iter.next().unwrap();
        return (p1, p2);
    }

    let median_index = slopes.len() / 2 - if slopes.len() % 2 == 0 { 1 } else { 0 };
    let mut slopes_copy = slopes.clone();
    // Using the f64-specific quickselect
    let median_slope = quickselect_f64(&mut slopes_copy, median_index, 0, None);

    let mut small = BTreeSet::new();
    let mut equal = BTreeSet::new();
    let mut large = BTreeSet::new();

    for i in 0..slopes.len() {
        if slopes[i] < median_slope {
            small.insert(pairs[i]);
        } else if (slopes[i] - median_slope).abs() < f64::EPSILON {
            equal.insert(pairs[i]);
        } else {
            large.insert(pairs[i]);
        }
    }

    let mut max_slope = f64::NEG_INFINITY;
    for point in &points {
        max_slope = max_slope.max(point.y - median_slope * point.x);
    }

    let mut max_set = Vec::new();
    for point in &points {
        if (point.y - median_slope * point.x - max_slope).abs() < f64::EPSILON {
            max_set.push(*point);
        }
    }

    let left = *max_set.iter().min().unwrap();
    let right = *max_set.iter().max().unwrap();

    if left.x <= vertical_line && right.x > vertical_line {
        return (left, right);
    }

    if right.x <= vertical_line {
        for &(_, p2) in &large {
            candidates.insert(p2);
        }
        for &(_, p2) in &equal {
            candidates.insert(p2);
        }
        for &(p1, p2) in &small {
            candidates.insert(p1);
            candidates.insert(p2);
        }
    }

    if left.x > vertical_line {
        for &(p1, _) in &small {
            candidates.insert(p1);
        }
        for &(p1, _) in &equal {
            candidates.insert(p1);
        }
        for &(p1, p2) in &large {
            candidates.insert(p1);
            candidates.insert(p2);
        }
    }

    bridge(candidates, vertical_line)
}

fn connect(lower: Point, upper: Point, points: &BTreeSet<Point>) -> Vec<Point> {
    if lower == upper {
        return vec![lower];
    }

    let points_vec: Vec<Point> = points.iter().copied().collect();
    let mid_index = points_vec.len() / 2 - 1;

    let mut points_copy = points_vec.clone();
    let max_left = quickselect(&mut points_copy, mid_index, 0, None);

    let mut points_copy = points_vec.clone();
    let min_right = quickselect(&mut points_copy, mid_index + 1, 0, None);

    let (left, right) = bridge(points.clone(), (max_left.x + min_right.x) / 2.0);

    let mut points_left = BTreeSet::new();
    points_left.insert(left);

    let mut points_right = BTreeSet::new();
    points_right.insert(right);

    for &point in points {
        if point.x < left.x {
            points_left.insert(point);
        } else if point.x > right.x {
            points_right.insert(point);
        }
    }

    let mut left_result = connect(lower, left, &points_left);
    let right_result = connect(right, upper, &points_right);

    left_result.extend(right_result);
    left_result
}

fn upper_hull(points: &BTreeSet<Point>) -> Vec<Point> {
    let mut lower = *points.iter().next().unwrap();

    // Find the lowest point with the same x-coordinate as the minimum
    for &point in points {
        if point.x == lower.x && point.y > lower.y {
            lower = point;
        }
    }

    let upper = *points.iter().rev().next().unwrap();

    let mut filtered_points = BTreeSet::new();
    filtered_points.insert(lower);
    filtered_points.insert(upper);

    for &p in points {
        if lower.x < p.x && p.x < upper.x {
            filtered_points.insert(p);
        }
    }

    connect(lower, upper, &filtered_points)
}

fn convex_hull(points: &BTreeSet<Point>) -> Vec<Point> {
    let upper = upper_hull(points);

    let mut flipped_points = BTreeSet::new();
    for &p in points {
        flipped_points.insert(Point::new(-p.x, -p.y));
    }

    let flipped_upper = upper_hull(&flipped_points);
    let mut lower = flipped(&flipped_upper);

    let mut result = upper.clone();

    if !result.is_empty() && !lower.is_empty() && *result.last().unwrap() == *lower.first().unwrap() {
        lower.remove(0);
    }

    if !result.is_empty() && !lower.is_empty() && *result.first().unwrap() == *lower.last().unwrap() {
        lower.pop();
    }

    result.extend(lower);

    result
}

fn main() {
    // Create points for a 2D projection of a 3D simplex
    let mut points = BTreeSet::new();
    points.insert(Point::new(0.0, 0.0));   // projection of [0.0, 0.0, 0.0]
    points.insert(Point::new(1.0, 0.0));   // projection of [1.0, 0.0, 0.0]
    points.insert(Point::new(0.0, 1.0));   // projection of [0.0, 1.0, 0.0]
    points.insert(Point::new(0.5, 0.5));   // projection of [0.0, 0.0, 1.0] (projected to 2D)

    println!("Input points:");
    for p in &points {
        println!("({}, {})", p.x, p.y);
    }

    let hull = convex_hull(&points);

    println!("\nConvex hull points:");
    for p in &hull {
        println!("({}, {})", p.x, p.y);
    }
}
