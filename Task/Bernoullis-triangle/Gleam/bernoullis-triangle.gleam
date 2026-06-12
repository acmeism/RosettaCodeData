import gleam/int
import gleam/io
import gleam/list
import gleam/result

pub fn main() {
  bernoulli(from: [1], rows: 15)
}

fn bernoulli(from row: List(Int), rows n: Int) {
  case n {
    0 -> Nil
    x -> {
      print_list(row)
      bernoulli(next_row(row), x - 1)
    }
  }
}

fn print_list(list: List(Int)) {
  case list {
    [] -> io.println("[]")
    [x] -> io.println(int.to_string(x))
    [x, ..rest] -> {
      io.print(int.to_string(x) <> " ")
      print_list(rest)
    }
  }
}

fn next_row(row: List(Int)) -> List(Int) {
  let next =
    row
    |> list.window_by_2
    |> list.map(fn(x) { x.0 + x.1 })
    |> list.prepend(1)
  next |> list.append([list.last(next) |> result.unwrap(1) |> int.add(1)])
}
