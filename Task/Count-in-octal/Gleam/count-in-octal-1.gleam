import gleam/int
import gleam/io

pub fn main() {
  count_octal(from: 1)
}

fn count_octal(from n: Int) -> Nil {
  n |> int.to_base8 |> io.println
  count_octal(n + 1)
}
