import gleam/int
import gleam/io
import gleam/list
import gleam/result

pub fn main() {
  int.range(1, 11, [1], fn(acc, _) {
    list.each(acc, fn(x) { io.print(int.to_string(x)) })
    io.println("")
    next_looknsay(acc)
  })
}

pub fn next_looknsay(list: List(Int)) -> List(Int) {
  list.chunk(list, fn(x) { x })
  |> list.flat_map(fn(x) { [list.length(x), list.first(x) |> result.unwrap(0)] })
}
