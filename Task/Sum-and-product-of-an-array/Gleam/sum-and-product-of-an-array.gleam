import gleam/int
import gleam/io

pub fn main() {
  let list = [1, 2, 3, 4, 5]
  let sum = int.sum(list)
  let product = int.product(list)
  io.println("sum = " <> int.to_string(sum))
  io.println("product = " <> int.to_string(product))
}
