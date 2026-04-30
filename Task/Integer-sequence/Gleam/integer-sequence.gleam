import gleam/int
import gleam/io

pub fn main() {
  count_forever(from: 1)
}

pub fn count_forever(from n: Int) -> Nil {
  n |> int.to_string |> io.println
  count_forever(n + 1)
}
