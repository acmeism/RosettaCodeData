pub fn main() {
  let _ = echo dot_product([1, 3, -5], [4, -2, -1])
  let _ = echo dot_product([1, 3, -5], [4, -2])
}

pub fn dot_product(u: List(Int), v: List(Int)) -> Result(Int, String) {
  dot_product_loop(u, v, 0)
}

fn dot_product_loop(u: List(Int), v: List(Int), sum: Int) -> Result(Int, String) {
  case u, v {
    [], [_, ..] -> Error("Inputs must have the same length.")
    [_, ..], [] -> Error("Inputs must have the same length.")
    [x, ..rest_u], [y, ..rest_v] ->
      dot_product_loop(rest_u, rest_v, x * y + sum)
    [], [] -> Ok(sum)
  }
}
