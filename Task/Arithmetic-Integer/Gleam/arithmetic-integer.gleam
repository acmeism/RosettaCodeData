import gleam/format
import gleam/int
import gleam/result
import input

pub fn main() -> Result(Nil, Nil) {
  // Using these libs:
  // https://hexdocs.pm/input/index.html
  // https://hexdocs.pm/format/gleam/format.html
  use str1 <- result.try(input.input(prompt: "> "))
  use str2 <- result.try(input.input(prompt: "> "))
  use a <- result.try(int.parse(str1))
  use b <- result.try(int.parse(str2))
  format.printf("Sum = ~w~n", [a + b])
  format.printf("Difference = ~w~n", [a - b])
  format.printf("Product = ~w~n", [a * b])
  format.printf("Quotient = ~w~n", [a / b])
  format.printf("Remainder = ~w~n", [a % b])
  Ok(Nil)
}
