import gleam/io
import gleam/list
import gleam/string
import simplifile as file

pub fn main() {
  let dictionary = "unixdict.txt"
  case file.read(dictionary) {
    Ok(text) -> {
      text
      |> string.split(on: "\n")
      |> list.filter(valid)
      |> list.each(io.println)
    }
    Error(e) ->
      io.println_error(
        "There was a problem reading "
        <> dictionary
        <> ": "
        <> file.describe_error(e),
      )
  }
}

/// Determines whether a lowercase string uses every vowel
/// exactly once and is longer than ten letters.
///
pub fn valid(word: String) -> Bool {
  valid_loop(word, 0, 0, 0, 0, 0, 0)
}

fn valid_loop(
  word: String,
  a: Int,
  e: Int,
  i: Int,
  o: Int,
  u: Int,
  idx: Int,
) -> Bool {
  case word, a, e, i, o, u {
    _, 2, _, _, _, _ -> False
    _, _, 2, _, _, _ -> False
    _, _, _, 2, _, _ -> False
    _, _, _, _, 2, _ -> False
    _, _, _, _, _, 2 -> False
    "", 1, 1, 1, 1, 1 -> idx > 10
    "", _, _, _, _, _ -> False
    "a" <> rest, _, _, _, _, _ -> valid_loop(rest, a + 1, e, i, o, u, idx + 1)
    "e" <> rest, _, _, _, _, _ -> valid_loop(rest, a, e + 1, i, o, u, idx + 1)
    "i" <> rest, _, _, _, _, _ -> valid_loop(rest, a, e, i + 1, o, u, idx + 1)
    "o" <> rest, _, _, _, _, _ -> valid_loop(rest, a, e, i, o + 1, u, idx + 1)
    "u" <> rest, _, _, _, _, _ -> valid_loop(rest, a, e, i, o, u + 1, idx + 1)
    _, _, _, _, _, _ ->
      valid_loop(string.drop_start(word, 1), a, e, i, o, u, idx + 1)
  }
}

