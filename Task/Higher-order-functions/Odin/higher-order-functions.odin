package main

import "core:fmt"

first :: proc(fn: proc() -> string) -> string {
  return fn()
}

second :: proc() -> string {
  return "second"
}

main :: proc() {
  fmt.println(first(second))  // prints: second
}
