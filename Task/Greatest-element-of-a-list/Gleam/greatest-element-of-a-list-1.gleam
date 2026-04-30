import gleam/int
import gleam/list

pub fn main() {
  [1, 99, 136, 4, 3, 22, 111]
  |> list.max(int.compare)
  |> echo
}
