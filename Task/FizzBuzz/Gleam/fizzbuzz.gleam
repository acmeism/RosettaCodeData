import gleam/int
import gleam/io
import gleam/list

pub fn main() {
  int.range(100, 0, [], list.prepend)
  |> list.map(fizz_buzz)
  |> list.each(io.println)
}

pub fn fizz_buzz(i) {
  case i % 3, i % 5 {
    0, 0 -> "FizzBuzz"
    0, _ -> "Fizz"
    _, 0 -> "Buzz"
    _, _ -> int.to_string(i)
  }
}
