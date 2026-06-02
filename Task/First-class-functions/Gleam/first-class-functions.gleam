import gleam/float
import gleam/io
import gleam/list
import gleam_community/maths

fn compose(f, g) {
  fn(x) { f(g(x)) }
}

pub fn main() {
  let functions = [maths.sin, maths.cos, fn(x) { x *. x *. x }]
  let inverses = [maths.asin, maths.acos, fn(x) { maths.nth_root(x, 3) }]
  let composed = list.map2(inverses, functions, compose)
  use composed_function <- list.each(composed)
  let assert Ok(result) = composed_function(0.5)
  io.println(float.to_string(result))
}
