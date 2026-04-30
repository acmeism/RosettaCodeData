import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  [2, 1, 5, 3, 4]
  |> list.sort(int.compare)
  |> list.map(int.to_string)
  |> string.join(" ")
  |> io.println
}
