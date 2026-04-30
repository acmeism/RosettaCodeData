import simplifile

pub fn main() {
  // simplifile.delete function deletes a file or directory.
  let assert Ok(_) = simplifile.delete("docs")
  let assert Ok(_) = simplifile.delete("input.txt")
  let assert Ok(_) = simplifile.delete("/docs")
  let assert Ok(_) = simplifile.delete("/input.txt")
}
