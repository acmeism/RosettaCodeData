 // Defines a generic struct where x and y can be of any type T
struct Point<T> {
    x: T,
    y: T,
}
fn main() {
    let p = Point { x: 1.0, y: 2.5 }; // p is of type Point<f64>
    println!("{}, {}", p.x, p.y);
}
