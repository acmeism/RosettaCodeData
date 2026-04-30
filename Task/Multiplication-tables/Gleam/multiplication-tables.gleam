import gleam/int
import gleam/io
import gleam/string

pub fn main() {
  io.print(" x |")
  int.range(1, 13, Nil, fn(_, x) { show(x, to: 4) })
  io.println("\n---+" <> string.repeat("-", times: 48))
  use _, x <- int.range(1, 13, Nil)
  show(x, to: 2)
  io.print(" |" <> string.repeat(" ", { x - 1 } * 4))
  int.range(x, 13, Nil, fn(_, y) { show(x * y, 4) })
  io.println("")
}

fn show(n: Int, to padding: Int) -> Nil {
  n
  |> int.to_string
  |> string.pad_start(to: padding, with: " ")
  |> io.print
}
