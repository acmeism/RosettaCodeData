import gleam/int
import gleam/list

pub fn main() {
  int.range(100, 1, [], list.prepend)
  |> list.filter(is_wprime)
  |> echo
}

pub fn is_wprime(n: Int) -> Bool {
  case n {
    _ if n < 2 -> False
    _ -> { factorial(n - 1) + 1 } % n == 0
  }
}

fn factorial(n: Int) -> Int {
  factorial_loop(n, 1)
}

fn factorial_loop(n: Int, product: Int) -> Int {
  case n {
    0 -> product
    _ -> factorial_loop(n - 1, n * product)
  }
}
