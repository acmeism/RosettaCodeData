import gleam/io
import gleam/list
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(text) = file.read(from: "unixdict.txt")
  let is_vowel = string.contains(does: "aeiou", contain: _)
  text
  |> string.split(on: "\n")
  |> list.filter(fn(word) {
    string.length(word) > 9
    && word
    |> string.to_graphemes
    |> list.window_by_2
    |> list.all(fn(x) { is_vowel(x.0) != is_vowel(x.1) })
  })
  |> list.each(io.println)
}
