import gleam/list

pub fn main() {
  [1, 14, 99, 23]
  |> list.map(fn(x) { x * 2 })
  |> echo
}
