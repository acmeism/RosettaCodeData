import gleam/list

pub fn main() {
  let _ = [1, 4, 8, 3] |> list.reduce(fn(x, y) { x + y })  // Ok(16)
  // Or, with a seed
  let _ = [1, 4, 8, 3] |> list.fold(from: 100, with: fn(x, y) { x + y }) // 116
}
