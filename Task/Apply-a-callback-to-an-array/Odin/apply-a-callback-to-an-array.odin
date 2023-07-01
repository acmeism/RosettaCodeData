package main

import "core:slice"
import "core:fmt"

squared :: proc(x: int) -> int {
  return x * x
}

main :: proc() {
  arr := []int{1, 2, 3, 4, 5}
  res := slice.mapper(arr, squared)

  fmt.println(res)  // prints: [1, 4, 9, 16, 25]
}
