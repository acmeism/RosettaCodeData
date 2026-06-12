/// Solves a system of two linear equations.
///
pub fn solve(eq1: #(Int, Int, Int), eq2: #(Int, Int, Int)) -> #(Int, Int) {
  let #(a1, b1, c1) = eq1
  let #(a2, b2, c2) = eq2
  let x = { b2 * c1 - b1 * c2 } / { b2 * a1 - b1 * a2 }
  let y = { a1 * x - c1 } / -b1
  #(x, y)
}

pub fn main() {
  echo solve(#(3, 1, -1), #(2, -3, -19))
}
