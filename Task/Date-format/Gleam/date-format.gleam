import birl as date
import dateformat
import gleam/io

pub fn main() {
  let now = date.now()
  now |> date.to_naive_date_string |> io.println
  let assert Ok(s) = dateformat.format("dddd, MMMM D, YYYY", now)
  io.println(s)
}
