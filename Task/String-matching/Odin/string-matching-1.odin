package main

import "core:fmt"
import "core:strings"

main :: proc() {
  using strings

  s := "Hello world"

  fmt.println(has_prefix(s, "He"), contains(s, "wo"), has_suffix(s, "ld"))
  // Output: true true true

  fmt.println(index(s, "wo"))
  // Output: 6
}
