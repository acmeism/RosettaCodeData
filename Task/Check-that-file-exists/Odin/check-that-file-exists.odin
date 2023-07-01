package main

import "core:os"

main :: proc() {
  os.exists("input.txt")
  os.exists("/input.txt")
  os.exists("docs")
  os.exists("/docs")
}
