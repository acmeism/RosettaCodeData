package main

import "core:fmt"

foreign import libc "system:c"

@(default_calling_convention="c")
foreign libc {
  @(link_name="strdup") cstrdup :: proc(_: cstring) -> cstring ---
  @(link_name="free")   cfree   :: proc(_: rawptr) ---
}

main :: proc() {
  s1 : cstring = "hello"
  s2 := cstrdup(s1)
  fmt.printf("{}\n", s2)
  cfree(rawptr(s2))
