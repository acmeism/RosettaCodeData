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
      |> list.filter(only_4_e)
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

fn only_4_e(word: String) -> Bool {
  only_4_e_loop(word, 0)
}

fn only_4_e_loop(word: String, count: Int) -> Bool {
  case word {
    "" -> count > 3
    "a" <> _ | "i" <> _ | "o" <> _ | "u" <> _ -> False
    "e" <> rest -> only_4_e_loop(rest, count + 1)
    _ -> only_4_e_loop(string.drop_start(word, 1), count)
  }
}
