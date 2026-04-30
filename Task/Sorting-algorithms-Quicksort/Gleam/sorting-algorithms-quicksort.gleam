import gleam/int
import gleam/list
import gleam/order.{type Order, Lt}

pub fn quick_sort(xs: List(a), compare: fn(a, a) -> Order) -> List(a) {
  case xs {
    [] -> []
    [x, ..xs] -> {
      let #(left, right) = list.partition(xs, fn(y) { compare(y, x) == Lt })
      let ql = quick_sort(left, compare)
      let qr = quick_sort(right, compare)
      list.append(list.append(ql, [x]), qr)
    }
  }
}

pub fn main() {
  [31, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8] |> quick_sort(int.compare) |> echo
}
