import gleam/io
import simplifile

pub fn main() {
  case simplifile.read_directory("/somepath") {
    Ok([]) -> io.println("Directory is empty")
    Ok([_, ..]) -> io.println("Directory isn't empty")
    Error(_) -> io.println("Some error")
  }
}
