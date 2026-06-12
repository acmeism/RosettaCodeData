import gleam/int
import gleam/io
import gleam/list
import gleam/result

pub fn main() {
  use x <- list.each([1, 3, 7, 15])
  io.print(int.to_string(x) <> ": ")
  int.range(1, 11, x, fn(acc, _) {
    let assert Ok(y) = gospers_hack(acc)
    io.print(int.to_string(y) <> " ")
    y
  })
  io.println("")
}

pub fn gospers_hack(n: Int) -> Result(Int, Nil) {
  let c = int.bitwise_and(n, -n)
  let r = n + c
  int.bitwise_exclusive_or(r, n)
  |> int.bitwise_shift_right(2)
  |> int.divide(c)
  |> result.map(int.bitwise_or(_, r))
}
