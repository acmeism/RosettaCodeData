use std::cmp::Ordering;
use std::collections::HashSet;
use std::hash::{Hash, Hasher};

#[derive(Clone, Copy, PartialEq, Eq, Debug, Hash)]
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    fn new(x: i32, y: i32) -> Self {
        Point { x, y }
    }

    fn rotate90(&self) -> Self {
        Point::new(self.y, -self.x)
    }

    fn rotate180(&self) -> Self {
        Point::new(-self.x, -self.y)
    }

    fn rotate270(&self) -> Self {
        Point::new(-self.y, self.x)
    }

    fn reflect_in_y_axis(&self) -> Self {
        Point::new(-self.x, self.y)
    }

    fn contiguous_points(&self) -> Vec<Point> {
        vec![
            Point::new(self.x - 1, self.y),
            Point::new(self.x + 1, self.y),
            Point::new(self.x, self.y - 1),
            Point::new(self.x, self.y + 1),
        ]
    }

    fn to_string(&self) -> String {
        format!("({}, {})", self.x, self.y)
    }
}

impl Ord for Point {
    fn cmp(&self, other: &Self) -> Ordering {
        match self.x.cmp(&other.x) {
            Ordering::Equal => self.y.cmp(&other.y),
            other_ordering => other_ordering,
        }
    }
}

impl PartialOrd for Point {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

#[derive(Clone, PartialEq, Eq, Debug)]
struct Polyomino {
    points: Vec<Point>,
}

impl Hash for Polyomino {
    fn hash<H: Hasher>(&self, state: &mut H) {
        // Hash the sorted points to ensure consistent hashing regardless of order
        let mut points = self.points.clone();
        points.sort();
        for point in points {
            point.hash(state);
        }
    }
}

impl Polyomino {
    fn new(points: Vec<Point>) -> Self {
        Polyomino { points }
    }

    fn empty() -> Self {
        Polyomino { points: Vec::new() }
    }

    fn rotations_and_reflections(&self) -> Vec<Polyomino> {
        let mut result = vec![
            Polyomino::empty(),
            Polyomino::empty(),
            Polyomino::empty(),
            Polyomino::empty(),
            Polyomino::empty(),
            Polyomino::empty(),
            Polyomino::empty(),
            Polyomino::empty(),
        ];

        for point in &self.points {
            result[0].points.push(*point);
            result[1].points.push(point.rotate90());
            result[2].points.push(point.rotate180());
            result[3].points.push(point.rotate270());
            result[4].points.push(point.reflect_in_y_axis());
            result[5].points.push(point.reflect_in_y_axis().rotate90());
            result[6].points.push(point.reflect_in_y_axis().rotate180());
            result[7].points.push(point.reflect_in_y_axis().rotate270());
        }
        result
    }

    fn minima(&self) -> (i32, i32) {
        let mut min_x = i32::MAX;
        let mut min_y = i32::MAX;

        for point in &self.points {
            if point.x < min_x {
                min_x = point.x;
            }
            if point.y < min_y {
                min_y = point.y;
            }
        }
        (min_x, min_y)
    }

    fn translate_to_origin(&self) -> Polyomino {
        let (min_x, min_y) = self.minima();
        let mut translated = Polyomino::empty();

        for point in &self.points {
            translated.points.push(Point::new(point.x - min_x, point.y - min_y));
        }
        translated.points.sort();
        translated
    }

    fn canonical(&self) -> Polyomino {
        let polyominoes = self.rotations_and_reflections();
        let mut min_polyomino = polyominoes[0].translate_to_origin();

        for i in 1..polyominoes.len() {
            let polyomino_i = polyominoes[i].translate_to_origin();
            if polyomino_i.points < min_polyomino.points {
                min_polyomino = polyomino_i;
            }
        }
        min_polyomino
    }

    fn new_points(&self) -> Vec<Point> {
        let mut result = HashSet::new();
        for point in &self.points {
            for pt in point.contiguous_points() {
                if !self.points.contains(&pt) {
                    result.insert(pt);
                }
            }
        }
        result.into_iter().collect()
    }

    fn new_polyominoes(&self) -> Vec<Polyomino> {
        let mut polyominoes = Vec::new();

        for point in self.new_points() {
            let mut points_copy = self.points.clone();
            points_copy.push(point);
            polyominoes.push(Polyomino::new(points_copy).canonical());
        }
        polyominoes
    }

    fn to_string(&self) -> String {
        let mut result = String::from("[");
        for (i, point) in self.points.iter().enumerate() {
            result.push_str(&point.to_string());
            if i < self.points.len() - 1 {
                result.push_str(", ");
            }
        }
        result.push(']');
        result
    }
}

impl Ord for Polyomino {
    fn cmp(&self, other: &Self) -> Ordering {
        self.points.cmp(&other.points)
    }
}

impl PartialOrd for Polyomino {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn monomino() -> Polyomino {
    Polyomino::new(vec![Point::new(0, 0)])
}

fn polyominoes_of_rank(number: u32) -> Vec<Polyomino> {
    if number == 0 {
        return vec![Polyomino::empty()];
    }
    if number == 1 {
        return vec![monomino()];
    }

    let mut polyominoes = HashSet::new();
    for polyomino in polyominoes_of_rank(number - 1) {
        for poly in polyomino.new_polyominoes() {
            polyominoes.insert(poly);
        }
    }
    polyominoes.into_iter().collect()
}

fn main() {
    let n = 5;
    println!("All free polyominoes of rank {}", n);
    for polyomino in polyominoes_of_rank(n) {
        println!("{}", polyomino.to_string());
    }

    let k = 10;
    println!("\nNumber of free polyominoes of ranks 1 to {}:", k);
    for i in 1..=k {
        print!("{} ", polyominoes_of_rank(i).len());
    }
    println!();
}
