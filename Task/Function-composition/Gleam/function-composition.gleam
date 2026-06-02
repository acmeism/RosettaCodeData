pub fn compose(f: fn(a) -> a, g: fn(a) -> a) -> fn(a) -> a {
  fn(x) { f(g(x)) }
}

pub fn main() {
  let times_2_plus_1 = compose(fn(x) { x + 1 }, fn(x) { x * 2 })
  echo times_2_plus_1(7)
}
