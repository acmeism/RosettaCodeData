package main

import "core:mem"

main :: proc() {
  ptr := mem.alloc(1000)  // Allocate heap memory
  mem.free(ptr)
}
