import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  list.append([1, 2, 3], [4, 5, 6])
  |> list.map(int.to_string)
  |> string.join(" ")
  |> io.println
}
