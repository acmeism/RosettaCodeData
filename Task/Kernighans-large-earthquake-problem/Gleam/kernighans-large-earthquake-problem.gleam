import gleam/float
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile as file

pub fn main() {
  case file.read("data.txt") {
    Ok(text) -> {
      text
      |> string.split(on: "\n")
      |> list.filter(is_strong_earthquake(_, 6.0))
      |> list.each(io.println)
    }
    Error(e) ->
      io.println_error(
        "There was a problem reading data.txt: " <> file.describe_error(e),
      )
  }
}

fn is_strong_earthquake(entry: String, threshold: Float) -> Bool {
  case
    entry
    |> string.split(on: " ")
    |> list.last
    |> result.unwrap("")
    |> float.parse
  {
    Ok(x) -> x >. threshold
    Error(_) -> {
      io.println_error("malformed entry: " <> entry <> "\nskipping...")
      False
    }
  }
}
