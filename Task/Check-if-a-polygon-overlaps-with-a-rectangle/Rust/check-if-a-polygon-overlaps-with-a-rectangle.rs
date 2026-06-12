use std::f32;
use std::fmt;

// --- Struct Definitions ---

#[derive(Debug, Clone, Copy, PartialEq)]
struct Point {
    x: f32,
    y: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
struct Projection {
    min: f32,
    max: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
struct Vector {
    x: f32,
    y: f32,
}

#[derive(Debug, Clone, PartialEq)] // Cannot be Copy because Vec is not Copy
struct Polygon {
    vertices: Vec<Vector>,
    axes: Vec<Vector>,
}

#[derive(Debug, Clone, Copy, PartialEq)]
struct Rectangle {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
}

// --- Implementations ---

impl Projection {
    fn overlaps(&self, other: &Projection) -> bool {
        // !(self.max < other.min || other.max < self.min)
        self.max >= other.min && other.max >= self.min
    }
}

impl Vector {
    // Renamed from scalarProduct for Rust convention
    fn scalar_product(&self, other: &Vector) -> f32 {
        self.x * other.x + self.y * other.y
    }

    // Renamed from edgeWith
    fn edge_with(&self, other: &Vector) -> Vector {
        Vector {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }

    fn perpendicular(&self) -> Vector {
        Vector {
            x: -self.y,
            y: self.x,
        }
    }
}

// Implement Display trait for nice printing
impl fmt::Display for Vector {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

impl Polygon {
    // Constructor-like associated function
    fn new(points: &[Point]) -> Self {
        let vertices: Vec<Vector> = points
            .iter()
            .map(|p| Vector { x: p.x, y: p.y })
            .collect();

        let mut axes = Vec::new();
        if vertices.len() > 1 {
            for i in 0..vertices.len() {
                let vertex1 = vertices[i];
                let vertex2 = vertices[(i + 1) % vertices.len()]; // Wrap around
                let edge = vertex1.edge_with(&vertex2);
                axes.push(edge.perpendicular());
            }
        }

        Polygon { vertices, axes }
    }

    fn overlaps(&self, other: &Polygon) -> bool {
        // Combine axes from both polygons using iterator chaining
        let all_axes = self.axes.iter().chain(other.axes.iter());

        for axis in all_axes {
            let projection1 = self.projection_on_axis(axis);
            let projection2 = other.projection_on_axis(axis);

            if !projection1.overlaps(&projection2) {
                return false; // Found a separating axis
            }
        }

        true // No separating axis found
    }

    // Renamed from projectionOnAxis
    fn projection_on_axis(&self, axis: &Vector) -> Projection {
        let mut min = f32::INFINITY;
        let mut max = f32::NEG_INFINITY;

        for vertex in &self.vertices {
            let p = axis.scalar_product(vertex);
            // Using f32::min/max methods is idiomatic
            min = min.min(p);
            max = max.max(p);
        }

        Projection { min, max }
    }
}

// Implement Display trait for nice printing
impl fmt::Display for Polygon {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "[ ")?;
        for vertex in &self.vertices {
            write!(f, "{} ", vertex)?;
        }
        write!(f, "]")
    }
}

// --- Free Functions ---

// Renamed from rectangleToPolygon
fn rectangle_to_polygon(rectangle: &Rectangle) -> Polygon {
    let points = [
        Point { x: rectangle.x, y: rectangle.y },
        Point { x: rectangle.x + rectangle.width, y: rectangle.y },
        Point { x: rectangle.x + rectangle.width, y: rectangle.y + rectangle.height },
        Point { x: rectangle.x, y: rectangle.y + rectangle.height },
    ];
    Polygon::new(&points) // Pass points as a slice
}

// --- Main Function ---

fn main() {
    let polygon = Polygon::new(&[
        Point { x: 0.0, y: 0.0 },
        Point { x: 0.0, y: 2.0 },
        Point { x: 1.0, y: 4.0 },
        Point { x: 2.0, y: 2.0 },
        Point { x: 2.0, y: 0.0 },
    ]);

    let rectangle1 = Rectangle { x: 4.0, y: 0.0, width: 2.0, height: 2.0 };
    let rectangle2 = Rectangle { x: 1.0, y: 0.0, width: 8.0, height: 2.0 };

    let polygon1 = rectangle_to_polygon(&rectangle1);
    let polygon2 = rectangle_to_polygon(&rectangle2);

    println!("polygon: {}", polygon);
    println!("rectangle1 (as polygon): {}", polygon1);
    println!("rectangle2 (as polygon): {}", polygon2);
    println!(); // Equivalent to std::endl for flushing and newline

    println!("polygon and polygon1 overlap? {}", polygon.overlaps(&polygon1));
    println!("polygon and polygon2 overlap? {}", polygon.overlaps(&polygon2));
}
