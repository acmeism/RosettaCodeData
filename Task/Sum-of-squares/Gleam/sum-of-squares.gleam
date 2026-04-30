import gleam/int
import gleam/io
import gleam/list

pub fn main() -> Nil {
  list.fold([3, 1, 4, 1, 5, 9], 0, fn(acc, e) { e * e + acc })
  |> int.to_string
  |> io.println
}
