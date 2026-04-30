pub fn max(
  over list: List(a),
  with compare: fn(a, a) -> Order,
) -> Result(a, Nil) {
  case list {
    [] -> Error(Nil)
    [first, ..rest] -> Ok(max_loop(rest, compare, first))
  }
}

fn max_loop(list, compare, max) {
  case list {
    [] -> max
    [first, ..rest] ->
      case compare(first, max) {
        order.Gt -> max_loop(rest, compare, first)
        order.Lt | order.Eq -> max_loop(rest, compare, max)
      }
  }
}
