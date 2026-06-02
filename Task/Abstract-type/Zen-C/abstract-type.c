import "std/math.zc"

trait Shape {
    fn area(self) -> f64;
}

struct Square {
    side_length: f64;
}

impl Shape for Square {
    fn area(self) -> f64 {
        return self.side_length * self.side_length;
    }
}

struct Circle {
    radius: f64;
}

impl Shape for Circle {
    fn area(self) -> f64 {
        return Math::PI() * self.radius * self.radius;
    }
}

// Prints the area of any Shape.
fn print_area(shape: Shape) {
    println "{shape.area()}";
}

fn main() {
    let square = Square{side_length: 5.0};
    let circle = Circle{radius: 2.5};
    print_area(&square);
    print_area(&circle);
}
