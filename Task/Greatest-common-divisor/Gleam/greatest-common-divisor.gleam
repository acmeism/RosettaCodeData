import gleam/int
import gleam/io

pub fn main() {
  gcd(40_902, 24_140)
  |> int.to_string
  |> io.println
}

pub fn gcd(a, b) {
  gcd_loop(int.absolute_value(a), int.absolute_value(b))
}

fn gcd_loop(a, b) {
  case b {
    0 -> a
    _ -> gcd_loop(b, a % b)
  }
}
