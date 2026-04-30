import gleam/list
import gleam/set
import gleam/string

pub fn main() {
  echo count_jewels("aAAbbbb", "aA")
}

/// Counts how many letters in stones are in jewels.
///
pub fn count_jewels(stones: String, jewels: String) -> Int {
  let jewels = string.to_graphemes(jewels) |> set.from_list
  stones
  |> string.to_graphemes
  |> list.count(set.contains(jewels, _))
}
