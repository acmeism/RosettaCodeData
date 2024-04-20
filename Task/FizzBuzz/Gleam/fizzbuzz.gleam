import gleam/int
import gleam/io
import gleam/iterator

pub fn main() {
  iterator.range(1, 101)
  |> iterator.map(to_fizzbuzz)
  |> iterator.map(io.println)
  |> iterator.run
}

fn to_fizzbuzz(n: Int) -> String {
  case n % 3, n % 5 {
    0, 0 -> "FizzBuzz"
    0, _ -> "Fizz"
    _, 0 -> "Buzz"
    _, _ -> int.to_string(n)
  }
}
