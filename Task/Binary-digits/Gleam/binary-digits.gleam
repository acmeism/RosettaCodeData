import gleam/format
import gleam/list

pub fn main() -> Nil {
  // Using format library: https://hexdocs.pm/format/gleam/format.html
  [5, 50, 9000]
  |> list.map(format.printf("~.2B~n", _))
  Nil
}
