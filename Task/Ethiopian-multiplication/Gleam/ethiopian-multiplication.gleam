import gleam/int

pub fn main() {
  let _ = echo ethiopian_multiply(17, 34)
}

pub fn ethiopian_multiply(x: Int, y: Int) -> Int {
  ethiopian_multiply_loop(x, y, 0)
}

fn ethiopian_multiply_loop(x: Int, y: Int, product: Int) -> Int {
  case x, y, is_even(x) {
    0, _, _ -> product
    x, y, True -> ethiopian_multiply_loop(halve(x), double(y), product)
    x, y, False -> ethiopian_multiply_loop(halve(x), double(y), product + y)
  }
}

fn halve(x: Int) -> Int {
  int.bitwise_shift_right(x, 1)
}

fn double(x: Int) -> Int {
  int.bitwise_shift_left(x, 1)
}

fn is_even(x: Int) -> Bool {
  int.bitwise_and(x, 1) == 0
}
