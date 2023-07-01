package main

import "core:os"

main :: proc() {
  data, ok := os.read_entire_file("input.txt")
  defer delete(data)

  ok = os.write_entire_file("output.txt", data)
}
