import gleam/int
import gleam/io

pub fn main() {
  case int.base_parse("1234", 10) {
    Ok(_) -> io.println("String is numeric")
    Error(_) -> io.println("String isn't numeric")
  }
}
