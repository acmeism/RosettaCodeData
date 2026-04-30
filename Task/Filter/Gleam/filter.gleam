import gleam/list

pub fn main() {
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  |> list.filter(fn(x) { x % 2 == 0 })
  |> echo
}
