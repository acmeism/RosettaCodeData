import gleam/bool
import gleam/int
import gleam/io

pub fn main() {
  1
  |> int.is_odd
  |> bool.to_string
  |> io.println

  2
  |> int.is_even
  |> bool.to_string
  |> io.println
}
