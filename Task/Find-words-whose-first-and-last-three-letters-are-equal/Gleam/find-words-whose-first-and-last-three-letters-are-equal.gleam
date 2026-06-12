import gleam/io
import gleam/list
import gleam/string
import simplifile as file

pub fn main() {
  let dictionary = "unixdict.txt"
  case file.read(dictionary) {
    Ok(text) ->
      text
      |> string.split(on: "\n")
      |> list.filter(fn(word) {
        string.length(word) > 5
        && string.slice(word, at_index: 0, length: 3)
        == string.slice(word, at_index: -3, length: 3)
      })
      |> list.each(io.println)
    Error(e) ->
      io.println_error(
        "There was a problem reading "
        <> dictionary
        <> ": "
        <> file.describe_error(e),
      )
  }
}
