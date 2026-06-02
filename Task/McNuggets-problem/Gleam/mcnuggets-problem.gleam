import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}

pub fn main() {
  case non_mcnuggets(upto: 100) |> set.to_list |> list.max(int.compare) {
    Ok(n) -> int.to_string(n) |> io.println
    Error(_) -> io.println_error("No candidates. Try setting a higher limit.")
  }
}

pub fn non_mcnuggets(upto limit: Int) -> Set(Int) {
  let candidates = int.range(limit, 0, [], list.prepend) |> set.from_list
  use c, x <- int.range(0, limit / 6, candidates)
  use c, y <- int.range(0, limit / 9, c)
  use c, z <- int.range(0, limit / 5, c)
  set.delete(c, x * 6 + y * 9 + z * 20)
}
