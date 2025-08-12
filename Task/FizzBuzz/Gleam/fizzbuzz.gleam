import gleam/int
import gleam/io
import gleam/yielder

pub fn main() {
  yielder.range(1, 101)
  |> yielder.map(to_fizzbuzz)
  |> yielder.map(io.println)
  |> yielder.run
}

fn to_fizzbuzz(n: Int) -> String {
  case n % 3, n % 5 {
    0, 0 -> "FizzBuzz"
    0, _ -> "Fizz"
    _, 0 -> "Buzz"
    _, _ -> int.to_string(n)
  }
}
