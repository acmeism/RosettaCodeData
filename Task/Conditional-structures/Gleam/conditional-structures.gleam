import gleam/int
import gleam/io

pub fn conditional_example(x: Int) {
  // if's below are called "pattern guards".
  case x {
    x if x < 0 -> io.println(x |> int.to_string <> " is negative")
    x if x == 0 -> io.println(x |> int.to_string <> " is zero")
    _ -> io.println(x |> int.to_string <> " is positive")
  }
}

pub fn main() {
  // Pattern matching is the only conditional structure in Gleam.
  conditional_example(-10)
  conditional_example(0)
  conditional_example(10)
}
