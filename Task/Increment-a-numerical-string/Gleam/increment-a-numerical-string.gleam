import gleam/int
import gleam/io
import gleam/result

pub fn main() {
  "12349"
  |> int.parse
  |> result.unwrap(-1)
  |> int.add(1)
  |> int.to_string
  |> io.println
}
