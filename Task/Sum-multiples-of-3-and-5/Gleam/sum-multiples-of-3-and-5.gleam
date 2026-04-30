import gleam/format

pub fn sum_three_five(x: Int) -> Int {
  sum_three_five_helper(x - 1, 0)
}

fn sum_three_five_helper(x: Int, total: Int) -> Int {
  case x {
    x if x < 3 -> total
    x if x % 3 == 0 || x % 5 == 0 -> sum_three_five_helper(x - 1, total + x)
    _ -> sum_three_five_helper(x - 1, total)
  }
}

pub fn main() -> Nil {
  format.printf("~B~n", [sum_three_five(1000)])
}
