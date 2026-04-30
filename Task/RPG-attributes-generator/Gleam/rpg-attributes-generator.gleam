import gleam/int
import gleam/io

pub fn main() {
  let #(attrs, total) = attributes()
  echo attrs
  io.println("Total: " <> int.to_string(total))
}

pub fn attributes() -> #(List(Int), Int) {
  attributes_loop([], 6, 0, 0)
}

fn attributes_loop(
  attrs: List(Int),
  iter: Int,
  good_attrs: Int,
  total: Int,
) -> #(List(Int), Int) {
  let attr = attribute()
  case iter, good_attrs >= 2 && total >= 75, attr >= 15 {
    0, False, _ -> attributes_loop([], 6, 0, 0)
    0, True, _ -> #(attrs, total)
    _, _, True ->
      attributes_loop([attr, ..attrs], iter - 1, good_attrs + 1, total + attr)
    _, _, False ->
      attributes_loop([attr, ..attrs], iter - 1, good_attrs, total + attr)
  }
}

fn attribute() -> Int {
  attribute_loop(4, 6, 0)
}

fn attribute_loop(i, min, total) -> Int {
  case i, int.random(6) + 1 {
    0, _ -> total - min
    _, x if x < min -> attribute_loop(i - 1, x, total + x)
    _, x -> attribute_loop(i - 1, min, total + x)
  }
}
