package main

import "core:fmt"
import "core:path/filepath"

main :: proc() {
  matches, _err := filepath.glob("*.odin")
  for match in matches do fmt.println(match)
}
