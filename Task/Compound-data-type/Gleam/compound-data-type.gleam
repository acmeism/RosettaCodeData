import gleam/float
import gleam/int
import gleam/io

// In Gleam, a type with one variant which has the same
// name as the type is called a "compound", "record" or
// a "product" type.
// Given a record, it's fields can either be accessed via the dot (.) operator
// or pattern matched.
pub type Point(a) {
  Point(x: a, y: a)
}

pub fn point_to_string(p: Point(a), to_string: fn(a) -> String) -> String {
  // Example of pattern matching records:
  let Point(x, y) = p
  "Point{x = " <> x |> to_string <> ", y = " <> y |> to_string <> "}"
  // We can also use the . operator:
  // "Point{x = " <> p.x |> to_string <> ", y = " <> p.y |> to_string <> "}"
}

pub fn main() {
  let p1: Point(Int) = Point(10, 5)
  let p2: Point(Float) = Point(10.0, 5.0)
  io.println(point_to_string(p1, int.to_string))
  io.println(point_to_string(p2, float.to_string))
}
