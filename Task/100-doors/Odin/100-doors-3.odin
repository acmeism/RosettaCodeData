package main

import "core:fmt"
import "core:math"

main :: proc() {
 using fmt

  Door_State :: enum {Closed, Open}

  doors := [?]Door_State { 0..<100 = .Closed }

  for i in  1..=100 {
     res := math.sqrt_f64( f64(i) )
     if math.mod_f64( res, 1) == 0 {
        doors[i-1] = .Open
     } else {
        doors[i-1] = .Closed
     }
     println("Door: ", i, " -> ", doors[i-1])
  }
}
