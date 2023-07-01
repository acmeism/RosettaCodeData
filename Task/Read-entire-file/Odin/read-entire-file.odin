package main

import "core:os"
import "core:fmt"

main :: proc() {
  data, ok := os.read_entire_file("input.txt")
  assert(ok, "Could not open file")
  defer delete(data)

  fmt.print(string(data))
}
