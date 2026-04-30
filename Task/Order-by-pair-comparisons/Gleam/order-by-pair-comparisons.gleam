import gleam/io
import gleam/list
import gleam/order.{Gt, Lt}
import in

pub fn main() {
  ["violet", "red", "green", "indigo", "blue", "yellow", "orange"]
  |> list.sort(by: fn(a, b) {
    io.print("Is " <> a <> " > " <> b <> "? (y/n) ")
    case in.read_line() {
      Ok("y\n") -> Gt
      Ok(_) -> Lt
      Error(_) -> panic as "Error reading from standard input."
    }
  })
  |> echo
}
