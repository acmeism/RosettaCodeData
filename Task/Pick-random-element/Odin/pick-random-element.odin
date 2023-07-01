package main

import "core:fmt"
import "core:math/rand"

main :: proc() {
  list := []string{"foo", "bar", "baz"}
  rand_index := rand.int_max(len(list))
  fmt.println(list[rand_index])
}
