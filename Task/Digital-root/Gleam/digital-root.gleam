import gleam/int
import gleam/io
import gleam/list

pub fn sum_digits(n: Int) -> Int {
  sum_digits_base(n, 10)
}

pub fn sum_digits_base(n: Int, base: Int) -> Int {
  sum_digits_helper(n, base, 0)
}

fn sum_digits_helper(n: Int, base: Int, acc: Int) -> Int {
  case n, base, acc {
    0, _, acc -> acc
    n, base, acc if n < base -> acc + n
    n, base, acc -> sum_digits_helper(n / base, base, acc + { n % base })
  }
}

pub fn persistance_root(x: Int) -> #(Int, Int) {
  persistance_root_helper(sum_digits(x), 1)
}

fn persistance_root_helper(x: Int, n: Int) -> #(Int, Int) {
  case x, n {
    x, n if x < 10 -> #(n, x)
    x, n -> persistance_root_helper(sum_digits(x), n + 1)
  }
}

pub fn task() {
  let ns = [627_615, 39_390, 588_225, 393_900_588_225]
  let res = list.map(ns, fn(x) { #(x, persistance_root(x)) })
  list.each(res, fn(pair) {
    let #(x, #(y, z)) = pair
    io.println(
      x |> int.to_string
      <> " has additive persitence "
      <> y |> int.to_string
      <> " and digital root of "
      <> z |> int.to_string,
    )
  })
}

pub fn main() {
  task()
}
