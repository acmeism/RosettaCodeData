import gleam/int
import gleam/io
import gleam/list

pub fn main() {
  ["apple", "orange"]
  |> list.length
  |> int.to_string
  |> io.println
}
