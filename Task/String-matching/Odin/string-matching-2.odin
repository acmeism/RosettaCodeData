package main

import "core:fmt"
import "core:strings"

main :: proc() {
  using strings

  s := "abracadabra"
  s1 := "abr"

  fmt.println( "1. ", s, " starts with ", s1, " --> ", has_prefix(s, s1))

  fmt.println( "2. ", s, " contains ", s1, " --> ", contains (s, s1))
  ndx := index(s, s1)
  if ndx > -1 {
    fmt.println(" 2.1. at location -> ", ndx)
    ndx += len(s1)
    for ndx < len(s) {
      found := index(s[ndx:], s1)
      if found > -1 {
        fmt.println(" 2.2. at location -> ", found+ndx)
        ndx += found+len(s1)
      } else {
        break
      }
    }
    fmt.println(" 2.2. and that's all.")
  }

  fmt.println( "3. ", s, " ends with ", s1, " --> ", has_suffix(s, s1))
}
