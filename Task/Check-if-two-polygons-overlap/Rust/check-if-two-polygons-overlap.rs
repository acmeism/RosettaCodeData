use std::fmt;

// Replaces C++ Point class
#[derive(Debug, Copy, Clone, PartialEq)] // Add common traits
struct Point {
    pub x: f32,
    pub y: f32,
}

// Replaces C++ Vector class
#[derive(Debug, Copy, Clone, PartialEq)] // Add common traits
struct Vector {
    pub x: f32,
    pub y: f32,
}

impl Vector {
    // Renamed from scalarProduct to snake_case
    // Takes immutable references (&) as it doesn't modify self or other
    pub fn scalar_product(&self, other: &Vector) -> f32 {
        self.x * other.x + self.y * other.y
    }

    // Renamed from edgeWith to snake_case
    // Takes immutable references, returns a new Vector
    pub fn edge_with(&self, other: &Vector) -> Vector {
        Vector {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }

    // Takes an immutable reference, returns a new Vector
    pub fn perpendicular(&self) -> Vector {
        Vector {
            x: -self.y,
            y: self.x,
        }
    }
}

// Implement Display trait for nice printing (replaces C++ to_string)
impl fmt::Display for Vector {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

// Replaces C++ Projection class
#[derive(Debug, Copy, Clone, PartialEq)] // Add common traits
struct Projection {
    pub min: f32,
    pub max: f32,
}

impl Projection {
    // Takes immutable references (&)
    pub fn overlaps(&self, other: &Projection) -> bool {
        !(self.max < other.min || other.max < self.min)
    }
}

// Replaces C++ Polygon class
#[derive(Debug, Clone)] // Cannot be Copy because Vec is not Copy
struct Polygon {
    // Fields are private by default unless marked `pub`
    vertices: Vec<Vector>,
    axes: Vec<Vector>,
}

impl Polygon {
    // Associated function acting as a constructor
    // Takes a slice of Points (&[Point]) to be more flexible (accepts Vec, array, etc.)
    pub fn new(points: &[Point]) -> Self {
        let vertices = Self::compute_vertices(points);
        let axes = Self::compute_axes(&vertices);
        Polygon { vertices, axes }
    }

    // Helper function, not public (private to the module)
    fn compute_vertices(points: &[Point]) -> Vec<Vector> {
        // Use iterators for a more idiomatic Rust approach
        points
            .iter()
            .map(|p| Vector { x: p.x, y: p.y })
            .collect()
    }

    // Helper function, not public (private to the module)
    fn compute_axes(vertices: &[Vector]) -> Vec<Vector> {
        let mut axes = Vec::new();
        if vertices.len() < 2 {
            return axes; // Handle cases with less than 2 vertices
        }

        for i in 0..vertices.len() {
            let p1 = vertices[i];
            // Use modulo (%) for wrap-around indexing
            let p2 = vertices[(i + 1) % vertices.len()];
            let edge = p1.edge_with(&p2);
            axes.push(edge.perpendicular());
        }
        axes
    }

    // Public method to check overlaps
    // Takes immutable references (&)
    pub fn overlaps(&self, other: &Polygon) -> bool {
        // Combine axes from both polygons using iterators and chain
        let all_axes = self.axes.iter().chain(other.axes.iter());

        for axis in all_axes {
            let projection1 = self.projection_on_axis(axis);
            let projection2 = other.projection_on_axis(axis);

            if !projection1.overlaps(&projection2) {
                return false; // Found a separating axis
            }
        }

        true // No separating axis found, polygons overlap
    }

    // Public method to project polygon onto an axis
    // Takes immutable references (&)
    pub fn projection_on_axis(&self, axis: &Vector) -> Projection {
        // Use Rust's float constants
        let mut min = f32::INFINITY;
        let mut max = f32::NEG_INFINITY;

        // Iterate over borrowed vertices
        for vertex in &self.vertices {
            let p = axis.scalar_product(vertex);
            // Use min/max functions for clarity
            min = min.min(p);
            max = max.max(p);
        }

        Projection { min, max }
    }
}

// Implement Display trait for nice printing (replaces C++ to_string)
impl fmt::Display for Polygon {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "[ ")?;
        // Iterate and use the Display impl of Vector
        for vertex in &self.vertices {
            write!(f, "{} ", vertex)?;
        }
        write!(f, "]")
    }
}

fn main() {
    // Use vec! macro for easy vector creation
    let polygon1 = Polygon::new(&[
        Point { x: 0.0, y: 0.0 }, Point { x: 0.0, y: 2.0 }, Point { x: 1.0, y: 4.0 },
        Point { x: 2.0, y: 2.0 }, Point { x: 2.0, y: 0.0 }
    ]);

    let polygon2 = Polygon::new(&[
        Point { x: 4.0, y: 0.0 }, Point { x: 4.0, y: 2.0 }, Point { x: 5.0, y: 4.0 },
        Point { x: 6.0, y: 2.0 }, Point { x: 6.0, y: 0.0 }
    ]);

    let polygon3 = Polygon::new(&[
        Point { x: 1.0, y: 0.0 }, Point { x: 1.0, y: 2.0 }, Point { x: 5.0, y: 4.0 },
        Point { x: 9.0, y: 2.0 }, Point { x: 9.0, y: 0.0 }
    ]);

    // Use println! macro, which automatically uses the Display trait
    println!("polygon1: {}", polygon1);
    println!("polygon2: {}", polygon2);
    println!("polygon3: {}", polygon3);
    println!(); // Print an empty line

    // println! automatically formats bool as true/false (like C++ std::boolalpha)
    println!("polygon1 and polygon2 overlap? {}", polygon1.overlaps(&polygon2));
    println!("polygon1 and polygon3 overlap? {}", polygon1.overlaps(&polygon3));
    println!("polygon2 and polygon3 overlap? {}", polygon2.overlaps(&polygon3));
}
