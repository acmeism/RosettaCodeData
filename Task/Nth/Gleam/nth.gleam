import gleam/int
import gleam/io

pub fn main() {
  show_nths(from: 0, to: 25)
  show_nths(from: 250, to: 265)
  show_nths(from: 1000, to: 1025)
}

pub fn nth(n: Int) -> String {
  int.to_string(n)
  <> case n % 100, n % 10 {
    11, _ | 12, _ | 13, _ -> "th"
    _, 1 -> "st"
    _, 2 -> "nd"
    _, 3 -> "rd"
    _, _ -> "th"
  }
}

fn show_nths(from x: Int, to y: Int) -> Nil {
  int.range(x, y, Nil, fn(_, x) { io.print(nth(x) <> " ") })
  io.println("")
}
