import gleam/int
import gleam/io

pub fn safe_div(a, b: Int) -> Result(Int, Nil) {
  case b {
    0 -> Error(Nil)
    _ -> Ok(a / b)
  }
}

pub fn main() {
  // In Gleam division by 0 is not an error and returns 0.
  // But we can make a safe_div function if we desire.
  case safe_div(10, 5) {
    Error(Nil) -> io.print_error("Division by zero")
    Ok(d) -> io.println("result of division is " <> d |> int.to_string)
  }

  case safe_div(10, 0) {
    Error(Nil) -> io.print_error("Division by zero")
    Ok(d) -> io.println("result of division is " <> d |> int.to_string)
  }
}
