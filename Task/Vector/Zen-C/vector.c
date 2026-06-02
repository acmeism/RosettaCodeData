import "std/core.zc"
import "std/math.zc"

struct Vector {
    x: double;
    y: double;
}

impl Vector {
    // Standard initialization
    fn new(x: double, y: double) -> Vector {
        return Vector { x: x, y: y };
    }

    // Initialize from start and end points
    fn from_points(x1: double, y1: double, x2: double, y2: double) -> Vector {
        return Vector { x: x2 - x1, y: y2 - y1 };
    }

    // Initialize from angle and length
    fn from_polar(angle: double, length: double) -> Vector {
        return Vector {
            x: length * Math::cos(angle),
            y: length * Math::sin(angle)
        };
    }

    // Maps to the '+' operator
    fn add(self, other: Vector) -> Vector {
        return Vector { x: self.x + other.x, y: self.y + other.y };
    }

    // Maps to the '-' operator
    fn sub(self, other: Vector) -> Vector {
        return Vector { x: self.x - other.x, y: self.y - other.y };
    }

    // Maps to the '*' operator
    fn mul(self, scalar: double) -> Vector {
        return Vector { x: self.x * scalar, y: self.y * scalar };
    }

    // Maps to the '/' operator
    fn div(self, scalar: double) -> Vector {
        if (scalar == 0.0) {
            println "Warning: Division by zero vector scalar!";
            return *self;
        }
        return Vector { x: self.x / scalar, y: self.y / scalar };
    }

    // Implicitly called during string interpolation
    fn to_string(self) -> char* {
        let buf = (char*)malloc(64);
        sprintf(buf, "Vector(x: %.2f, y: %.2f)", self.x, self.y);
        return buf;
    }

    fn show(self) {
        let s = self.to_string();
        println "{s}";
        free(s);
    }
}

fn main() {
    // Initialization
    let v1 = Vector::new(3.0, 4.0);
    println "v1 (new): {v1}";

    let v2 = Vector::from_points(0.0, 0.0, -1.0, 2.0);
    println "v2 (from_points): {v2}";

    println "v_polar (from_polar): {Vector::from_polar(Math::PI() / 4.0, 5.0)}";

    println "";

    // Operations
    println "v1 + v2: {v1 + v2}";
    println "v1 - v2: {v1 - v2}";
    println "v1 * 2.5: {v1 * 2.5}";
    println "v1 / 2.0: {v1 / 2.0}";
}
