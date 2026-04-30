import gleam/int
import gleam/io
import gleam/string

pub fn main() {
  count_octal(from: 1)
}

fn count_octal(from n: Int) -> Nil {
  n |> to_octal |> io.println
  count_octal(n + 1)
}

fn to_octal(n: Int) -> String {
  to_octal_loop(n, [])
}

fn to_octal_loop(n: Int, digits: List(String)) -> String {
  case n, digits {
    0, [] -> "0"
    0, _ -> string.concat(digits)
    _, _ -> to_octal_loop(n / 8, [n % 8 |> int.to_string, ..digits])
  }
}
