import gleam/int
import gleam/io
import gleam/string

fn digit_sum(n: Int) -> Int {
  digit_sum_loop(n, 0)
}

fn digit_sum_loop(n: Int, sum: Int) -> Int {
  case n {
    0 -> sum
    _ -> digit_sum_loop(n / 10, sum + n % 10)
  }
}

fn task_loop(m: Int, n: Int) -> Nil {
  case n, digit_sum(m * n) == n {
    71, _ -> Nil
    _, False -> task_loop(m + 1, n)
    _, True -> {
      io.print(int.to_string(m) |> string.pad_start(9, " "))
      case n % 10 == 0 {
        True -> io.println("")
        False -> Nil
      }
      task_loop(1, n + 1)
    }
  }
}

pub fn main() {
  task_loop(1, 1)
}
