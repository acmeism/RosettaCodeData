import gleam/io
import gleam/string

pub fn main() {
  // "" is an UTF8 encoded empty string in Gleam.
  io.println("")
  assert string.length("") == 0
}
